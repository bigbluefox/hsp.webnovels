﻿<%@ Page Title="" Language="C#" MasterPageFile="~/PageMaster/BootStrap.master" AutoEventWireup="true" CodeFile="Novel.aspx.cs" Inherits="Novel" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" Runat="Server">
    小说管理
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" Runat="Server">

    <link href="/Scripts/bootstrap/css/bootstrap-table.min.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-validator.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-datetimepicker.min.css" rel="stylesheet"/>
    <link href="/Styles/Hsp.Base.css" rel="stylesheet"/>

    <style type="text/css"></style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContainerContent" Runat="Server">

     <div class="page-header" style="display: block;">
        <h2 class="pull-left">
            <i class="fa fa-address-card-o"></i>
            <span>小说管理</span>
        </h2>
        <div class="pull-right">
            <ul class="breadcrumb">
                <li>
                    <a href="/Default.aspx"><i class="glyphicon glyphicon-home"></i>首页</a>
                </li>
                <li class="separator">
                    <i class="fa fa-angle-right"></i>
                </li>
                <li class="active"><% = WebName %></li>
            </ul>
        </div>
    </div>     

    <%--<h3 class="page-header">小说管理</h3>--%>

    <div class="result-message"></div>

<%--    <ol class="breadcrumb">
        <li>
            <a href="/Default.aspx">站点管理</a>
        </li>
        <li class="active"><% = WebName %></li>
    </ol>--%>

    <div id="toolbar">
        <div class="form-inline" role="form">
            <div class="form-group">
                <input name="search" class="form-control" type="text" placeholder="搜索内容">
            </div>

            <div class="form-group">
                <label class="sr-only" for="startDate">开始时间</label>
                <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd" data-link-field="startDate" data-link-format="yyyy-mm-dd">
                    <input class="form-control" size="16" type="text" value="" placeholder="选择开始时间..." readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
                <input type="hidden" id="startDate" value="">
            </div>
            <div class="form-group">
                <label class="sr-only" for="endDate">结束时间</label>
                <div class="input-group date form_date" data-date="" data-date-format="yyyy-mm-dd" data-link-field="endDate" data-link-format="yyyy-mm-dd">
                    <input class="form-control" size="16" type="text" value="" placeholder="选择结束时间..." readonly>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-remove"></span></span>
                    <span class="input-group-addon"><span class="glyphicon glyphicon-calendar"></span></span>
                </div>
                <input type="hidden" id="endDate" value="">
            </div>
            <button id="btnSearch" class="btn btn-primary">
                <i class="glyphicon glyphicon-search"></i> 查询
            </button>
            <button id="remove" class="btn btn-danger" disabled>
                <i class="glyphicon glyphicon-remove"></i> 批量删除
            </button>
            <button id="btnAdd" class="btn btn-primary">
                <i class="glyphicon glyphicon-plus"></i> 添加小说
            </button>
            <button id="btnCrawlContent" class="btn btn-primary">
                <i class="glyphicon icon-folder-plus"></i> 抓取内容
            </button>
        </div>
    </div>

    <table id="novel-table" data-mobile-responsive="true" data-toggle="table"></table>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ModalContent" Runat="Server">

    <div class="modal fade" id="editModel" tabindex="-1" role="dialog" aria-labelledby="editModelLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="editModelLabel">小说信息修改</h4>
                </div>
                <div class="modal-body">

                    <form>
                        <div class="form-group">
                            <label for="txtTitle">小说名称&nbsp;<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtTitle" placeholder="小说名称" required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtNovelUrl">小说地址&nbsp;<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtNovelUrl" placeholder="小说地址" required="required">
                        </div>
                        <div class="form-group" style="display: none;">
                            <label for="txtStartUrl">起始地址&nbsp;<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtStartUrl" placeholder="起始地址" required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtAuthor">小说作者</label>
                            <input type="text" class="form-control" id="txtAuthor" placeholder="小说作者">
                        </div>

                        <%--SELECT TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
                        , Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
                        FROM Novels--%>
                        
                        <div class="form-group">
                            <label for="txtChapterChar">章节模板</label>
                            <input type="text" class="form-control" id="txtChapterChar" placeholder="章节模板，默认“第$2章”，可输入“第$2节”" value="第$2章">
                        </div>
                        <div class="form-group" style="display: none;">
                            <label for="txtStartChapterIdx">起始序号</label>
                            <input type="text" class="form-control" id="txtStartChapterIdx" placeholder="起始章节序号，默认1">
                        </div>
                        <div class="form-group">
                            <label for="txtChapterType">章节处理</label>
                            <input type="text" class="form-control" id="txtChapterType" placeholder="章节处理类型，默认0">
                        </div>                        
                        <div class="form-group">
                            <label for="selStatus">小说状态</label>
                            <select class="form-control" id="selStatus">
                              <option value="0" selected="selected">连载中...</option>
                              <option value="1">已完本</option>
                              <option value="2">已太监</option>
                            </select>
                        </div>                        
                        <div class="form-group">
                            <div>
                                <div class="error-message"></div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <input type="hidden" id="txtId"><input type="hidden" id="txtWebId">
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span> 关闭
                    </button>
                    <button type="button" class="btn btn-primary" id="btnSave">
                        <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span> 保存
                    </button>

                </div>
            </div>
        </div>
    </div>

</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="SubScriptContent" Runat="Server">

<script src="/Scripts/bootstrap/js/bootstrap-table.min.js"></script>
<script src="/Scripts/bootstrap/js/locales/bootstrap-table-zh-CN.js"></script>
<script src="/Scripts/bootstrap/js/bootstrap-validator.min.js"></script>
<script src="/Scripts/bootstrap/js/locales/bootstrap-validator-zh-CN.js"></script>
<script src="/Scripts/bootstrap/js/bootstrap-datetimepicker.min.js"></script>
<script src="/Scripts/bootstrap/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>

<script src="/Scripts/Hsp.Base.js"></script>
<script src="/Scripts/Hsp.Formater.js"></script>
<script src="/Scripts/Hsp.Common.js"></script>
<script src="/Scripts/Hsp.Modal.js"></script>

<script type="text/javascript">

    var $table = $('#novel-table'),
        $remove = $('#remove'),
        selections = [],
        key = 'Id';

    var pageNumber = 1, width = 0, webId = "<% = WebId %>";
    var pageListUrl = "/Handler/NovelHandler.ashx?OP=LIST";
    var circleModalId = "circleModal", $circleModal = null; // 圆形进度条窗体及对象

    $(function() {

        width = Hsp.Common.AvailWidth();

        $table = $('#novel-table'),
            $remove = $('#remove');

        initTable();

        $('.form_date').datetimepicker({
            language: 'zh-CN',
            format: 'yyyy-mm-dd',
            weekStart: 1,
            todayBtn: 1,
            autoclose: 1,
            todayHighlight: 1,
            startView: 2,
            minView: 2,
            forceParse: 0
        });

        $('input[name="search"]').bind('keydown', function(event) {
            if (event.keyCode == "13") {
                $table.bootstrapTable({ url: pageListUrl });
                $table.bootstrapTable('refresh');
            }
        });

        $("#btnSearch").click(function() {
            $table.bootstrapTable({ url: pageListUrl });
            $table.bootstrapTable('refresh');
        });

        $("#btnAdd").click(function () {

            $("#txtWebId").val(webId);

            $("#editModelLabel").html("小说信息添加");
            $('#editModel').modal('toggle'); // 弹出添加窗体            
        });

        $circleModal = $("#" + circleModalId);

        // 抓取小说内容
        $("#btnCrawlContent").unbind('click').bind('click', function () {

            Hsp.Modal.CircleMessage(circleModalId, "操作进行中...");
            $("#" + circleModalId).modal("toggle");

            //setTimeout(function () {
            //    $("#" + circleModalId).modal("hide");
            //}, 5000); webId

            var url = "/Handler/ChapterHandler.ashx?OP=CRAWLCONTENT&webId=" + webId + "&novelId=";

            //$.get("demo_test.asp", function (data, status) { 
            //    alert("Data: " + data + "\nStatus: " + status);
            //});

            $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                if (data && data.success) {
                    $("#" + circleModalId).modal("hide");
                    modals.correct(data.Message);

                    refreshTable();
                } else {
                    modals.error(data.Message);
                }
            });

        });
    });

    // 刷新表格数据
    function refreshTable() {
        $table.bootstrapTable({ url: pageListUrl });
        $table.bootstrapTable('refresh');
    }

    // 表格初始化
    function initTable() {

        //先销毁表格  
        $table.bootstrapTable('destroy');

        $table.bootstrapTable({
            height: getHeight() - 35,
            toolbar: '#toolbar', //工具按钮用哪个容器
            method: 'get',
            url: pageListUrl, // 数据地址,  
            dataType: "json",
            striped: true, // 使表格带有条纹 
            idField: "Id", //标识哪个字段为id主键  
            pagination: true, // 在表格底部显示分页工具栏
            pageSize: 10,
            pageNumber: 1,
            pageList: [10, 20, 50, 100, 200, 500],
            sidePagination: "server", //表格分页的位置 
            //设置为undefined可以获取pageNumber，pageSize，searchText，sortName，sortOrder  
            //设置为limit可以获取limit, offset, search, sort, order  
            queryParamsType: "undefined",
            queryParams: function queryParams(params) { //设置查询参数  
                var param = {
                    pageNumber: params.pageNumber,
                    pageSize: params.pageSize,
                    webId: webId,
                    qname: $("input[name='search']").val(),
                    sdate: $("#startDate").val(),
                    edate: $("#endDate").val()
                };
                return param;
            },
            smartDisplay: true,
            columns: [
                [
                    {
                        field: 'checked',
                        checkbox: true
                    }, {
                        title: '序号',
                        field: 'RowNumber',
                        width: 60,
                        visible: width > Hsp.Mobile.HalfWidth,
                        align: 'center'
                    },

                    //SELECT TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
                    //, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
                    //FROM Novels

                    {
                        title: '编号',
                        field: 'Id',
                        align: 'center',
                        visible: false,
                        width: 60
                    }, {
                        field: 'WebName',
                        title: '站点',
                        halign: 'center',
                        align: 'left',
                        visible: webId.length === 0,
                        formatter: titleFormatter
                    }, {
                        field: 'Title',
                        title: '小说标题',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'NovelUrl',
                        title: '小说地址',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'Author',
                        title: '小说作者',
                        width: 90,
                        align: 'center'
                    }, {
                        field: 'LatestChapter',
                        title: '最新章节',
                        width: 150,
                        align: 'center'
                    }, {
                        field: 'ChildCount',
                        title: '章节数',
                        width: 60,
                        halign: 'center',
                        align: 'right',
                        visible: width > Hsp.Mobile.DefaultWidth,
                        formatter: titleFormatter
                    }, {
                        field: 'CreateTime',
                        title: '添加时间',
                        align: 'center',
                        width: 100,
                        visible: width > Hsp.Mobile.DefaultWidth,
                        formatter: dateFormatter
                    }, {
                        title: '操作',
                        width: 95,
                        align: 'center',
                        events: operateEvents,
                        formatter: operateFormatter
                    }
                ]
            ],
            formatLoadingMessage: function() {
                return "请稍等，正在加载中...";
            },
            formatNoMatches: function() { //没有匹配的结果  
                return '无符合条件的记录';
            },
            onLoadError: function(data) {
                $table.bootstrapTable('removeAll');
            },
            onClickRow: function(row) {
                //alert(row.Id);
                //window.location.href = ""; // "/qStock/qProInfo/" + row.Id;  
            }
        });

        // sometimes footer render error.

        setTimeout(function() {
            $table.bootstrapTable('resetView');
        }, 200);

        $table.on('check.bs.table uncheck.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function() {
                $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);

                // save your data, here just save the current page

                selections = getIdSelections();

                // push or splice the selections if you want to save all data selections

            });

        //$table.on('all.bs.table', function(e, name, args) {
        //    console.log(name, args);
        //});

        $remove.click(function() { // 批量删除
            var ids = getIdSelections();
            $table.bootstrapTable('remove', {
                field: 'Id',
                values: ids
            });
            $remove.prop('disabled', true);

            DelNovelByIds(ids); // 批量删除
        });

        $(window).resize(function() {
            $table.bootstrapTable('resetView', {
                height: getHeight()
            });
        });
    }


    function getIdSelections() {
        return $.map($table.bootstrapTable('getSelections'), function(row) {
            return row.Id;
        });
    }

    function responseHandler(res) {
        $.each(res.rows, function(i, row) {
            row.state = $.inArray(row.id, selections) !== -1;
        });
        return res;
    }

    // 操作内容格式化
    function operateFormatter(value, row, index) {
        return [
            '<a class="detail" href="javascript:void(0)" title="章节管理">',
            '<i class="glyphicon glyphicon-th-list"></i>',
            '</a>  ',
            '<a class="edit" href="javascript:void(0)" title="修改小说">',
            '<i class="glyphicon glyphicon-edit"></i>',
            '</a>  ',
            '<a class="remove" href="javascript:void(0)" title="删除小说">',
            '<i class="glyphicon glyphicon-remove"></i>',
            '</a>  ',
            '<a class="download" href="javascript:void(0)" title="下载小说">',
            '<i class="glyphicon glyphicon-book"></i>',
            '</a>'
        ].join('');
    }

    // 操作事件响应
    window.operateEvents = {
        'click .detail': function(e, value, row, index) {
            //alert('You click edit action, row: ' + JSON.stringify(row));

            var urlParams = "?webId=<% = WebId %>&webName=<% = HttpUtility.UrlEncode(WebName) %>";
            urlParams += "&novelId=" + row.Id + "&novelName=" + encodeURIComponent(row.Title);
            Page("Chapter.aspx" + urlParams);

        },
        'click .edit': function(e, value, row, index) {
            //alert('You click edit action, row: ' + JSON.stringify(row));

            $("#txtId").val(row.Id);
            $("#txtWebId").val(row.WebId);
            $("#txtTitle").val(row.Title);
            $("#txtNovelUrl").val(row.NovelUrl);
            $("#txtStartUrl").val(row.StartUrl);

            $("#txtAuthor").val(row.Author);
            $("#txtChapterChar").val(row.ChapterChar);
            $("#txtStartChapterIdx").val(row.StartChapterIdx);
            $("#txtChapterType").val(row.ChapterType);

            $("#selStatus").val(row.Status);

            //SELECT     TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
            //, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
            //FROM         Novels

            $("#editModelLabel").html("小说信息修改");
            $('#editModel').modal('toggle'); // 弹出名称修改

        },
        'click .remove': function(e, value, row, index) {
            $table.bootstrapTable('remove', {
                field: 'Id',
                values: [row.Id]
            });

            DelNovelById(row.Id); // 删除行数据，考虑要将上述表格响应纳入到删除操作中
        },
        'click .download': function (e, value, row, index) {

            // 进度条调用
            //Hsp.Modal.CircleMessage(circleModalId, "操作正在进行中，请稍候...");
            //$("#" + circleModalId).modal("toggle");

            var url = "/Handler/NovelHandler.ashx?OP=DOWNLOAD&ID=" + row.Id;
            //$.get(url + "&rnd=" + (Math.random() * 10), function (data) {
            //    //if (data) {
            //    //    //modals.correct(data.Message);
            //    //} else {
            //    //    modals.error(data.Message);
            //    //}

            //    $circleModal.modal("hide");
            //});

            //$.ajax({
            //    url: "/Handler/NovelHandler.ashx",
            //    type: 'GET',
            //    data: { OP: "DOWNLOAD", id: row.Id, rnd: Math.random() },
            //    success: function (rst) {
            //        $("#" + circleModalId).modal("hide");
            //    }
            //    , complete: function (xhr, errorText, errorType) {

            //        //debugger;

            //        //var p = "";

            //        //alert("请求完成后");

            //        //$circleModal.modal("hide");

            //        //$("#" + circleModalId).modal("hide");
            //    }
            //    , error: function(xhr, errorText, errorType) {
            //        alert("请求错误后");
            //    }
            //    , beforSend: function() {
            //        alert("请求之前");
            //    }
            //});

            window.open(url, "_blank");

        }
    };

    // 获取内容高度
    function getHeight() {
        return $(window).height() - $(".page-header").outerHeight(true); // $('h1').outerHeight(true) - $(".breadcrumb").outerHeight(true) - 36;
    }

    /// <summary>
    /// 删除小说
    /// </summary>

    function DelNovelById(id) {
        if (confirm("您确定要删除该小说吗？")) {
            var url = "/Handler/NovelHandler.ashx?OP=DELETE&ID=" + id;
            $.get(url + "&rnd=" + (Math.random() * 10), function(data) {
                if (data && data.success) {
                    modals.correct(data.Message);
                } else {
                    modals.error(data.Message);
                }
            });
        }
    }

    /// <summary>
    /// 批量删除小说
    /// </summary>

    function DelNovelByIds(ids) {
        if (confirm("您确定要批量删除这些小说吗？")) {
            var url = "/Handler/NovelHandler.ashx?OP=BATCHDELETE&IDs=" + ids;
            $.get(url + "&rnd=" + (Math.random() * 10), function(data) {
                if (data && data.success) {
                    modals.correct(data.Message);
                } else {
                    modals.error(data.Message);
                }
            });
        }
    }


    $(function() {
        // 模态窗体关闭事件 
        $('#editModel').on('hidden.bs.modal', function() { // 关闭模态窗体事件
            $("#txtId").val("");
            $("#txtWebId").val("");
            $("#txtTitle").val("");
            $("#txtNovelUrl").val("");
            $("#txtStartUrl").val("");

            $("#txtAuthor").val("");
            $("#txtChapterChar").val("");
            $("#txtStartChapterIdx").val("");
            $("#txtChapterType").val("");

            $("#selStatus").val(0);

            //SELECT     TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
            //, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
            //FROM         Novels
        });

        // 数据保存按钮点击事件 
        $("#btnSave").unbind("click").bind("click", function() {

            var params = {
                Id: $("#txtId").val(),
                WebId: $('#txtWebId').val(),
                Title: $("#txtTitle").val(),
                Author: $('#txtAuthor').val(),
                NovelUrl: $("#txtNovelUrl").val(),
                StartUrl: $('#txtStartUrl').val(),
                ChapterChar: $("#txtChapterChar").val(),
                StartChapterIdx: $("#txtStartChapterIdx").val(),
                ChapterType: $('#txtChapterType').val(),
                Status: $("#selStatus").val()
            };


            //SELECT TOP (200) Id, WebId, Title, NovelUrl, StartUrl, LatestChapter, Author, TypeId
            //, Status, RecentUpdate, ChapterCount, CreateTime, ChapterChar, StartChapterIdx, ChapterType
            //FROM Novels

            $.ajax({
                type: "POST",
                url: "/Handler/NovelHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                data: params,
                success: function(rst) {
                    if (rst && rst.success) {

                        Hsp.Common.Message($(".result-message"), rst.Message, "success", "fade");
                        $('#editModel').modal('hide');

                        refreshTable();
                    } else {
                        Hsp.Common.Message($(".error-message"), rst.Message, "error", "fade");
                    }
                }
                ,
                complete: function (xhr, errorText, errorType) {
                    //debugger;
                    //var p = "";
                    //alert("请求完成后");
                },
                error: function (xhr, errorText, errorType) {

                    debugger;
                    alert("请求错误后");
                },
                beforSend: function () {
                    alert("请求之前");
                }
            });
        });
    });

</script>

</asp:Content>