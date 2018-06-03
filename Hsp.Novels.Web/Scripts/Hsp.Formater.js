/*
 * 数据格式化处理
 */

if (!Hsp.Formatter) Hsp.Formatter = {};

// 日期格式化
function dateFormatter(value, row, index) {
    return value ? value.toDateTimeString("yyyy-MM-dd") : "";
}

// 日期时间格式化
function dateTimeFormatter(value, row, index) {
    return value ? value.toDateTimeString("yyyy-MM-dd HH:mm:SS") : "";
}

// 图标格式化
function iconFormatter(value, row, index) {
    return value ? '<i class="' + value + '"></i>' : "";
}

function detailFormatter(index, row) {
    var html = [];
    $.each(row, function(key, value) {
        html.push("<p><b>" + key + ":</b> " + value + "</p>");
    });
    return html.join("");
}

// 标题内容格式化
function titleFormatter(value, row, index) {
    return value ? "<span title='" + value + "'>" + value + "</span>" : "";
}

// 提示内容格式化
function tipsFormatter(value, row, index) {
    return value ? "<span title='" + value + "'>" + value + "</span>" : "";
}

// 有效性内容格式化
function validFormatter(value, row, index) {

    var format = "";
    if (value == 0) {
        format = '<i class="glyphicon glyphicon-remove"></i>';
    } else {
        format = '<i class="glyphicon glyphicon-ok"></i>';
    }

    return format;
}