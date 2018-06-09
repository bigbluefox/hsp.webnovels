
/*
 * 通用 JS 脚本
 */

/// <reference path="Hsp.Base.js" />

if (!Hsp.Common) Hsp.Common = {};


/// <summary>
/// 页面内容窗体有效宽度，Tli，2016-09-21
/// </summary>
Hsp.Common.AvailWidth = function () {
    return window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
};

/// <summary>
/// 生成Guid
/// </summary>

Hsp.Common.Guid = function () {
    var guid = "";
    for (var i = 1; i <= 32; i++) {
        var n = Math.floor(Math.random() * 16.0).toString(16);
        guid += n;
        if ((i == 8) || (i == 12) || (i == 16) || (i == 20))
            guid += "-";
    }
    return guid.toUpperCase();
};

/// <summary>
/// 对象转换为字符串方法
/// Hitech.Common.ObjToString(o)
/// </summary>
/// <history> Created At 2013.05.01 By Tli </history> 

Hsp.Common.ObjToString = function (o) {
    var r = [];
    var otype = "undefined";
    if (typeof o == "string") {
        return "\"" + o.replace(/(['\"\\])/g, "\\$1").replace(/(\n)/g, "\\n").replace(/(\r)/g, "\\r").replace(/(\t)/g, "\\t") + "\"";
    }
    if (typeof o == "undefined") {
        return otype;
    }
    if (typeof o == "object") {
        if (o === null) return "null";
        else if (!o.sort) {
            for (var i in o) {
                if (o.hasOwnProperty(i)) {
                    r.push('\"' + i + '\":' + HSP.Common.ObjToString(o[i]));
                }
            }
            r = "{" + r.join() + "}";
        } else {
            for (var j = 0; j < o.length; j++) {
                r.push(HSP.Common.ObjToString(o[j]));
            }
            r = "[" + r.join() + "]";
        }
        return r;
    }
    return o.toString();
};

/// <summary>
/// Bootstrap 消息处理
/// obj-消息对象主体
/// msg-消息内容
/// type-消息类型：success,warning,danger,info
/// fade-是否自动关闭
/// </summary>

Hsp.Common.Message = function (obj, msg, type, fade) {

    var typeMessage, typeIcon;

    switch (type.toLowerCase()) {
        case "success":
            typeMessage = "成功！";
            typeIcon = "ok-sign";
            break;
        case "warning":
            typeMessage = "警告！";
            typeIcon = "warning-sign";
            break;
        case "error":
        case "danger":
            type = "danger";
            typeMessage = "错误！";
            typeIcon = "remove-sign";
            break;
        case "info":
            typeMessage = "信息：";
            typeIcon = "info-sign";
            break;
        default:
            typeMessage = "信息：";
            typeIcon = "info-sign";
    }

    $('<div class="alert alert-' + type + ' alert-dismissible" role="alert">\
            <button type="button" class="close" data-dismiss="alert" aria-label="Close">\
                <span aria-hidden="true">&times;</span></button>\
            <span class="glyphicon glyphicon-' + typeIcon + '" aria-hidden="true"></span>\
            <span class="sr-only"></span>\
            <strong>' + typeMessage + '</strong> ' + msg + '\
        </div>').appendTo(obj);

    if (fade) {
        window.setTimeout(function () {
            $('[data-dismiss="alert"]').alert('close');
        }, 3000);
    }
};
