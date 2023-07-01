import request from "@/utils/request";

export default {
  getDevice: (id) => {
    return request({
      url: `/api/devices/${id}`,
      method: "get",
    });
  },
  getDevices: (params) => {
    return request({
      url: "/api/devices",
      method: "get",
      params,
    });
  },
  scan: (params) => {
    return request({
      url: "/api/scan",
      method: "get",
      params,
    });
  },
  reload: (params) => {
    return request({
      url: "/api/reload",
      method: "get",
      params,
    });
  },
  pair: (data) => {
    return request({
      url: "/api/pair",
      method: "post",
      data,
    });
  },

  upload: (data) => {
    return request({
      url: "/api/upload",
      method: "post",
      timeout: 30000,
      headers: {
        "Content-Type": "multipart/form-data",
      },
      data,
    });
  },

  getAppList: (params) => {
    return request({
      url: "/api/apps",
      method: "get",
      params,
    });
  },

  getInstallingApp: (params) => {
    return request({
      url: "/api/apps/installing",
      method: "get",
      params,
    });
  },

  saveApp: (data) => {
    return request({
      url: "/api/apps",
      method: "post",
      data,
    });
  },

  deleteApp: (id) => {
    return request({
      url: `/api/apps/${id}/delete`,
      method: "post",
    });
  },

  refreshApp: (id) => {
    return request({
      url: `/api/apps/${id}/refresh`,
      method: "post",
    });
  },

  getSettings: (params) => {
    return request({
      url: "/api/settings",
      method: "get",
      params,
    });
  },

  saveNotificationSettings: function (data) {
    return request({
      url: "/api/settings/notification",
      method: "post",
      data,
    });
  },

  saveTaskSettings: function (data) {
    return request({
      url: "/api/settings/task",
      method: "post",
      data,
    });
  },

  getServiceStatus: () => {
    return request({
      url: `/api/service/status`,
      method: "get",
    });
  },

  sendNotify: (params) => {
    return request({
      url: `/api/notify/send`,
      method: "get",
      params,
    });
  },
  sendTestNotify: (data) => {
    return request({
      url: `/api/notify/send/test`,
      method: "post",
      data,
    });
  },
};