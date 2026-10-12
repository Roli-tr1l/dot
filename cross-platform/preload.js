const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('dotAPI', {
  getClipboard: () => ipcRenderer.invoke('get-clipboard'),
  setClipboard: (text) => ipcRenderer.invoke('set-clipboard', text),
  executeCommand: (cmd) => ipcRenderer.invoke('execute-command', cmd),
  postNotification: (title, message) => ipcRenderer.invoke('post-notification', { title, message }),
  getBatteryStatus: () => ipcRenderer.invoke('get-battery-status'),
  setVolume: (level) => ipcRenderer.invoke('set-volume', level),
  openExternal: (url) => ipcRenderer.invoke('open-external', url),
  minimize: () => ipcRenderer.send('window-minimize'),
  close: () => ipcRenderer.send('window-close')
});
