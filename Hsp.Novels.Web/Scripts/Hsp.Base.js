/*
 * 基础 JS 脚本
 */

Hsp = {
    Browser: {
        IS_IE: 0 <= navigator.userAgent.indexOf("MSIE"),
        IS_IE6: 0 <= navigator.userAgent.indexOf("MSIE 6"),
        IS_IE11: !!navigator.userAgent.match(/Trident\/7\./),
        IS_QUIRKS: 0 <= navigator.userAgent.indexOf("MSIE") && (null == document.documentMode || 5 == document.documentMode),
        IS_EM: "spellcheck" in document.createElement("textarea") && 8 == document.documentMode,
        VML_PREFIX: "v",
        OFFICE_PREFIX: "o",
        IS_NS: 0 <= navigator.userAgent.indexOf("Mozilla/") && 0 > navigator.userAgent.indexOf("MSIE"),
        IS_OP: 0 <= navigator.userAgent.indexOf("Opera/"),
        IS_OT: 0 > navigator.userAgent.indexOf("Presto/2.4.") && 0 > navigator.userAgent.indexOf("Presto/2.3.") && 0 > navigator.userAgent.indexOf("Presto/2.2.") && 0 > navigator.userAgent.indexOf("Presto/2.1.") && 0 > navigator.userAgent.indexOf("Presto/2.0.") && 0 > navigator.userAgent.indexOf("Presto/1."),
        IS_SF: 0 <= navigator.userAgent.indexOf("AppleWebKit/") && 0 > navigator.userAgent.indexOf("Chrome/"),
        IS_IOS: navigator.userAgent.match(/(iPad|iPhone|iPod)/g) ? !0 : !1,
        IS_ANDROID: navigator.userAgent.match(/(android)/g) ? !0 : !1,
        IS_GC: 0 <= navigator.userAgent.indexOf("Chrome/"),
        IS_FF: 0 <= navigator.userAgent.indexOf("Firefox/"),
        IS_MT: 0 <= navigator.userAgent.indexOf("Firefox/") && 0 > navigator.userAgent.indexOf("Firefox/1.") && 0 > navigator.userAgent.indexOf("Firefox/2.") || 0 <= navigator.userAgent.indexOf("Iceweasel/") && 0 > navigator.userAgent.indexOf("Iceweasel/1.") && 0 > navigator.userAgent.indexOf("Iceweasel/2.") || 0 <= navigator.userAgent.indexOf("SeaMonkey/") && 0 > navigator.userAgent.indexOf("SeaMonkey/1.") || 0 <= navigator.userAgent.indexOf("Iceape/") && 0 > navigator.userAgent.indexOf("Iceape/1."),
        IS_SVG: 0 <= navigator.userAgent.indexOf("Firefox/") || 0 <= navigator.userAgent.indexOf("Iceweasel/") || 0 <= navigator.userAgent.indexOf("Seamonkey/") || 0 <= navigator.userAgent.indexOf("Iceape/") || 0 <= navigator.userAgent.indexOf("Galeon/") || 0 <= navigator.userAgent.indexOf("Epiphany/") || 0 <= navigator.userAgent.indexOf("AppleWebKit/") || 0 <= navigator.userAgent.indexOf("Gecko/") || 0 <= navigator.userAgent.indexOf("Opera/") || null != document.documentMode && 9 <= document.documentMode,
        NO_FO: !document.createElementNS || "[object SVGForeignObjectElement]" != document.createElementNS("http://www.w3.org/2000/svg", "foreignObject") || 0 <= navigator.userAgent.indexOf("Opera/"),
        IS_VML: "MICROSOFT INTERNET EXPLORER" == navigator.appName.toUpperCase(),
        IS_WIN: 0 < navigator.appVersion.indexOf("Win"),
        IS_MAC: 0 < navigator.appVersion.indexOf("Mac"),
        IS_TOUCH: "ontouchstart" in document.documentElement,
        IS_POINTER: null != window.navigator.msPointerEnabled ? window.navigator.msPointerEnabled : !1,
        IS_LOCAL: 0 > document.location.href.indexOf("http://") && 0 > document.location.href.indexOf("https://")
    },
    Common: {}, // 通用对象定义
    Mobile: {} // 移动对象定义
};

String.prototype.replaceAll = function (s1, s2) {
    return this.replace(new RegExp(s1, "gm"), s2);
};

// 敏感字符编码
String.prototype.encodeQuotes = function () {
    return this.replaceAll("'", "&!#39;").replaceAll("<script", "<+script").replaceAll('"', "&quot;");
};

// 敏感字符解码
String.prototype.decodeQuotes = function () {
    return this.replaceAll("&!#39;", "'").replaceAll("&quot;", '"');
};

String.prototype.clearHTML = function () {
    return this.replace(/<[^>].*?>/g, "");
};

// 判断字符串中是否只包含英文字母、汉字、数字、下划线、横杠及中文小括号（unicode）, YangJin, 2013-04-17
String.prototype.isContainSpecialSymbols = function () {
    var reg = /^(\w|[\u4E00-\u9FA5]|[\uff08-\uff09]|[\u3001]|\d|\-\u0020)+$/;
    return !(reg.test(this));
};

// 字符串中英文字母、汉字、数字、下划线、横杠及中文小括号以外的字符全去除, YangJin, 2013-04-17
// 提示消息模版：岗位名称中只能包含中英文字母、数字、下划线、横杠及中文小括号，其它特殊字符与空格将被系统自动去除，确定要继续？
String.prototype.removeSpecialSymbols = function () {
    var reg = /[^\w\u4E00-\u9FA5\uff08-\uff09\u3001\d\-\u0020]+/g;
    return this.replace(reg, "");
};

// 获取字符串中字节数 
String.prototype.getBytesLength = function () {
    return this.replace(/[^\x00-\xff]/gi, "--").length;
};

String.prototype.toDateTimeString = function (type) {
    var thisDate = new Date(parseInt(this.replace("/Date(", "").replace(")/", ""), 10));
    var year = thisDate.getFullYear();
    var month = thisDate.getMonth() + 1;
    var day = thisDate.getDate();

    var hh = thisDate.getHours();
    var mm = thisDate.getMinutes();
    var ss = thisDate.getSeconds();

    month = ("0" + month + "");
    month = month.substr(month.length - 2, month.length);

    day = ("0" + day + "");
    day = day.substr(day.length - 2, day.length);

    hh = ("0" + hh + "");
    hh = hh.substr(hh.length - 2, hh.length);

    mm = ("0" + mm + "");
    mm = mm.substr(mm.length - 2, mm.length);

    ss = ("0" + ss + "");
    ss = ss.substr(ss.length - 2, ss.length);

    if (type == "yyyy-MM-dd HH:mm:SS") {
        return year + "-" + month + "-" + day + " " + hh + ":" + mm + ":" + ss;
    } else {
        return year + "-" + month + "-" + day;
    }
    return thisDate.toCNString(type);
};

Array.prototype.indexOf = function (o) {
    for (var i = 0; i < this.length; i++)
        if (this[i] == o)
            return i;
    return -1;
};

Array.prototype.clear = function () {
    while (this.length > 0)
        this.removeAt(this.length - 1);
};

Array.prototype.insertAt = function (index, obj) {
    this.splice(index, 0, obj);
};

Array.prototype.removeAt = function (index) {
    this.splice(index, 1);
};

Array.prototype.remove = function (obj) {
    var index = this.indexOf(obj);
    if (index >= 0) {
        this.removeAt(index);
    }
};

// 移除数组中重复的项
Array.prototype.removeRepeat = function () {
    this.sort();
    var rs = [];
    var cr = false;
    var i;
    for (i = 0; i < this.length; i++) {
        if (!cr) cr = this[i];
        else if (cr == this[i]) rs[rs.length] = i;
        else cr = this[i];
    }
    var re = this;
    for (i = rs.length - 1; i >= 0; i--) re = re.del(rs[i]);
    return re;
};

// 获得数字数组的最大项
Array.prototype.getMax = function () {
    return this.sortNum(1)[0];
};

// 获得数字数组的最小项
Array.prototype.getMin = function () {
    return this.sortNum(0)[0];
};

// 数字数组排序
Array.prototype.sortNum = function (f) {
    if (!f) f = 0;
    if (f == 1) return this.sort(function (a, b) { return b - a; });
    return this.sort(function (a, b) { return a - b; });
};

Date.prototype.toDateTimeString = function (type) {
    var year = this.getFullYear();
    var month = this.getMonth() + 1;
    var day = this.getDate();

    var hh = this.getHours();
    var mm = this.getMinutes();
    var ss = this.getSeconds();

    month = ("0" + month + "");
    month = month.substr(month.length - 2, month.length);

    day = ("0" + day + "");
    day = day.substr(day.length - 2, day.length);

    hh = ("0" + hh + "");
    hh = hh.substr(hh.length - 2, hh.length);

    mm = ("0" + mm + "");
    mm = mm.substr(mm.length - 2, mm.length);

    ss = ("0" + ss + "");
    ss = ss.substr(ss.length - 2, ss.length);

    if (type == "yyyy-MM-dd HH:mm:SS") {
        return year + "-" + month + "-" + day + " " + hh + ":" + mm + ":" + ss;
    } else {
        return year + "-" + month + "-" + day;
    }
};

/* 让firefox支持 event全局对象，srcElement对象  */
function __firefox() {
    if (!HSP.Browser.IS_IE) {
        HTMLElement.prototype.__defineGetter__("runtimeStyle", __element_style);
        window.constructor.prototype.__defineGetter__("event", __window_event);
        Event.prototype.__defineGetter__("srcElement", __event_srcElement);
    }
}

function __element_style() {
    return this.style;
}

function __window_event() {
    return __window_event_constructor();
}

function __event_srcElement() {
    return this.target;
}

function __window_event_constructor() {
    if (document.all) {
        return window.event;
    }

    var _caller = __window_event_constructor.caller;
    while (_caller != null) {
        var _argument = _caller.arguments[0];
        if (_argument) {
            var _temp = _argument.constructor;
            if (_temp.toString().indexOf("Event") != -1) {
                return _argument;
            }
        }
        _caller = _caller.caller;
    }

    return null;
}

if (window.addEventListener) {
    __firefox();
}

String.prototype.lTrim = function (s) {
    s = (s ? s : "\\s"); //没有传入参数的，默认去空格
    s = ("(" + s + ")");
    var regLTrim = new RegExp("^" + s + "*", "g"); //拼正则
    return this.replace(regLTrim, "");
};

String.prototype.rTrim = function (s) {
    s = (s ? s : "\\s");
    s = ("(" + s + ")");
    var regRTrim = new RegExp(s + "*$", "g");
    return this.replace(regRTrim, "");
};

// 与微软的冲突
String.prototype.trim = function (s) {
    s = (s ? s : "\\s");
    s = ("(" + s + ")");
    var regTrim = new RegExp("(^" + s + "*)|(" + s + "*$)", "g");
    return this.replace(regTrim, "");
};

String.prototype.startsWith = function (str) {
    if (str == null || str == "" || this.length == 0 || str.length > this.length)
        return false;
    if (this.substr(0, str.length) == str)
        return true;
    else
        return false;
};
String.prototype.startWith = function (str) {
    if (str == null || str == "" || this.length == 0 || str.length > this.length)
        return false;
    if (this.substr(0, str.length) == str)
        return true;
    else
        return false;
};
String.prototype.endWith = function (str) {
    if (str == null || str == "" || this.length == 0 || str.length > this.length)
        return false;
    if (this.substring(this.length - str.length) == str)
        return true;
    else
        return false;
};

// 数字千分位格式化  
String.prototype.toThousands = function (num) {
    var num = (num || 0).toString(), result = "";
    while (num.length > 3) {
        result = "," + num.slice(-3) + result;
        num = num.slice(0, num.length - 3);
    }
    if (num) {
        result = num + result;
    }
    return result;
};
