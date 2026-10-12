const { app, BrowserWindow, ipcMain, clipboard, Notification, shell, Tray, Menu } = require('electron');
const path = require('path');
const { exec } = require('child_process');

let mainWindow = null;
let tray = null;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 600,
    height: 600,
    transparent: true,
    frame: false,
    alwaysOnTop: true,
    hasShadow: false,
    resizable: false,
    skipTaskbar: false,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      nodeIntegration: false,
      contextIsolation: true
    }
  });

  mainWindow.loadFile(path.join(__dirname, 'index.html'));
  mainWindow.setAlwaysOnTop(true, 'floating');

  mainWindow.on('closed', () => {
    mainWindow = null;
  });
}

function createTray() {
  const iconPath = path.join(__dirname, '..', 'Assets', 'AppIcon.png');
  tray = new Tray(iconPath);
  const contextMenu = Menu.buildFromTemplate([
    { label: 'Toggle Dot', click: () => {
        if (mainWindow.isVisible()) mainWindow.hide();
        else mainWindow.show();
      }
    },
    { type: 'separator' },
    { label: 'Quit Dot', click: () => app.quit() }
  ]);
  tray.setToolTip('Dot — AI Desktop Companion');
  tray.setContextMenu(contextMenu);
}

app.whenReady().then(() => {
  createWindow();
  try { createTray(); } catch (e) {}

  app.on('activate', () => {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});

// MARK: - IPC Handlers
ipcMain.handle('get-clipboard', () => {
  return clipboard.readText();
});

ipcMain.handle('set-clipboard', (_, text) => {
  clipboard.writeText(text);
  return true;
});

ipcMain.handle('execute-command', (_, cmd) => {
  return new Promise((resolve) => {
    const isWin = process.platform === 'win32';
    const shellExec = isWin ? 'powershell.exe -Command' : '/bin/sh -c';
    exec(`${shellExec} "${cmd.replace(/"/g, '\\"')}"`, (error, stdout, stderr) => {
      resolve({
        stdout: stdout || '',
        stderr: stderr || (error ? error.message : ''),
        exitCode: error ? 1 : 0
      });
    });
  });
});

ipcMain.handle('post-notification', (_, { title, message }) => {
  if (Notification.isSupported()) {
    new Notification({ title, body: message }).show();
    return true;
  }
  return false;
});

ipcMain.handle('get-battery-status', () => {
  return new Promise((resolve) => {
    if (process.platform === 'darwin') {
      exec('pmset -g batt', (_, stdout) => resolve(stdout ? stdout.trim() : 'Battery info unavailable'));
    } else if (process.platform === 'win32') {
      exec('WMIC Path Win32_Battery Get EstimatedChargeRemaining', (_, stdout) => resolve(stdout ? stdout.trim() : 'Battery info unavailable'));
    } else {
      exec('upower -i /org/freedesktop/UPower/devices/battery_BAT0', (_, stdout) => resolve(stdout ? stdout.trim() : 'Battery info unavailable'));
    }
  });
});

ipcMain.handle('open-external', (_, url) => {
  shell.openExternal(url);
  return true;
});

ipcMain.on('window-minimize', () => {
  if (mainWindow) mainWindow.minimize();
});

ipcMain.on('window-close', () => {
  if (mainWindow) mainWindow.hide();
});
