<%@ Page Title="" Language="C#" MasterPageFile="~/PageMaster/BootStrap.master" AutoEventWireup="true" CodeFile="Chapter.aspx.cs" Inherits="Chapter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" Runat="Server">
    章节管理
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" Runat="Server">

    <link href="/Scripts/bootstrap/css/bootstrap-table.min.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-validator.css" rel="stylesheet"/>

    <style type="text/css">
        #txtChapterTitle {
            -moz-text-overflow: ellipsis; /* for Firefox, mozilla */
            -ms-text-overflow: ellipsis;
            -o-text-overflow: ellipsis;
            overflow: hidden;
            text-align: left;
            text-overflow: ellipsis; /* for IE */
            white-space: nowrap;
        }
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContainerContent" Runat="Server">

    <h3 class="page-header">章节管理</h3>
    
    <div class="result-message"></div>

    <ol class="breadcrumb">
        <li>
            <a href="/Default.aspx">站点管理</a>
        </li>
        <li>
            <a href="/Novel.aspx?webId=<% = WebId %>&webName=<% = HttpUtility.UrlEncode(WebName)%>"><% = WebName %></a>
        </li>        
        <li class="active"><% = NovelName %></li>
    </ol>

    <div id="toolbar">
        <div class="form-inline" role="form">
            <div class="form-group">
                <input name="search" class="form-control" type="text" placeholder="搜索内容">
            </div>
            <button id="btnSearch" class="btn btn-primary">
                <i class="glyphicon glyphicon-search"></i> 查询
            </button>
            <button id="remove" class="btn btn-danger" disabled>
                <i class="glyphicon glyphicon-remove"></i> 批量删除
            </button>
            <button id="btnAdd" class="btn btn-primary">
                <i class="glyphicon icon-folder-plus"></i> 获取章节
            </button>
        </div>
    </div>

    <table id="chapter-table" data-mobile-responsive="true" data-toggle="table"></table>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ModalContent" Runat="Server">
    
    <div class="modal fade" id="crawlModel" tabindex="-1" role="dialog" aria-labelledby="crawlModelLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="crawlModelLabel">小说章节获取</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="txtChapterUrl" class="col-xs-6 col-sm-2 control-label">起始地址</label>
                            <div class="col-xs-6 col-sm-10">
                                <input type="text" class="form-control" id="txtChapterUrl" placeholder="起始地址" value="https://www.dashubao.net/book/85/85429/27100366.html">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtContentName" class="col-xs-6 col-sm-2 control-label">内容对象</label>
                            <div class="col-xs-6 col-sm-4">
                                <input type="text" class="form-control" id="txtContentName" placeholder="内容对象" value=".yd_text2 p">
                            </div>
                            <label for="txtHeaderName" class="col-xs-6 col-sm-2 control-label">标题对象</label>
                            <div class="col-xs-6 col-sm-4">
                                <input type="text" class="form-control" id="txtHeaderName" placeholder="标题对象" value=".oneline">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtNextName" class="col-xs-6 col-sm-2 control-label">地址对象</label>
                            <div class="col-xs-6 col-sm-4">
                                <input type="text" class="form-control" id="txtNextName" placeholder="下一章地址对象" value=".pereview a:last-child">
                            </div>
                            <label for="txtNextTitle" class="col-xs-6 col-sm-2 control-label">结束标识</label>
                            <div class="col-xs-6 col-sm-4">
                                <input type="text" class="form-control" id="txtNextTitle" placeholder="结束标识不含" value="">
                            </div> 
                        </div>
                        <div class="form-group">
                            <label for="txtContent" class="col-xs-6 col-sm-2 control-label">小说内容</label>
                            <div class="col-xs-6 col-sm-10">
                                <textarea class="form-control" id="txtContent" placeholder="抓取小说内容" rows="10"></textarea>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <div class="error-message"></div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <input id="txtNextUrl" type="hidden" /><input id="Hidden1" type="hidden" />
                    <div style="float: left;" id="txtChapterTitle"></div>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span> 关闭
                    </button>
                    <button type="button" class="btn btn-primary" id="btnClear">
                        <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span> 清空
                    </button>
                    <button type="button" class="btn btn-primary" id="btnTest">
                        <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span> 测试
                    </button>
                    <button type="button" class="btn btn-primary" id="btnCrawl">
                        <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span> 抓取
                    </button>
                </div>
            </div>
        </div>
    </div>       

    <div class="modal fade" id="editModel" tabindex="-1" role="dialog" aria-labelledby="editModelLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="editModelLabel">章节信息修改</h4>
                </div>
                <div class="modal-body">

                    <form>
                        <div class="form-group">
                            <label for="txtUserCode">登录账号<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtUserCode" placeholder="登录账号" required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtUserName">章节姓名<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtUserName" placeholder="章节姓名" required="required">
                        </div>
                                                <div class="form-group">
                            <label for="txtMobile">移动电话</label>
                            <input type="number" class="form-control" id="txtMobile" placeholder="移动电话">
                        </div>
                        <div class="form-group">
                            <label for="txtEmail">邮箱地址</label>
                            <input type="email" class="form-control" id="txtEmail" placeholder="邮箱地址">
                        </div>
                        
<%--//SELECT     TOP (200) Id, NovelId, Url, NextUrl, Chapter, ChapterIndex, ChapterName, HeadWord, Content, WordCount, UpdateTime
//FROM         Chapters--%>
                        

                        <div class="form-group">
                            <label>章节权限</label>
                            <div id="usertype">
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="chbAuthority1" name="chbAuthority" value="0">
                                    普通章节(0)
                                </label>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="chbAuthority2" name="chbAuthority" value="1">
                                    数据应用章节(1)
                                </label>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="chbAuthority3" name="chbAuthority" value="2">
                                    人力资源章节(2)
                                </label>
                                <label class="checkbox-inline">
                                    <input type="checkbox" id="chbAuthority4" name="chbAuthority" value="4">
                                    管理章节(4)
                                </label>
                            </div>
                        </div>

                        <div class="form-group">
                            <label>是否有效</label>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" id="chbAvailable">
                                    是否有效
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <div>
                                <div class="error-message"></div>
                            </div>
                        </div>
                    </form>

                </div>
                <div class="modal-footer">
                    <input type="hidden" id="txtUserId">
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

<script src="/Scripts/Hsp.Formater.js"></script>

<script type="text/javascript">

    var $table = $('#chapter-table'),
        $remove = $('#remove'),
        selections = [],
        key = 'Id';

    var pageNumber = 1, width = 0, isEnd = false;
    var webId = "<% = WebId %>", novelId = "<% = NovelId %>", novelName = "<% = NovelName %>";
    var pageListUrl = "/Handler/ChapterHandler.ashx?OP=LIST";

    $(function () {

        width = Hsp.Common.AvailWidth();

        $table = $('#chapter-table'),
            $remove = $('#remove');

        initTable();

        $('input[name="search"]').bind('keydown', function (event) {
            if (event.keyCode == "13") {
                $table.bootstrapTable({ url: pageListUrl });
                $table.bootstrapTable('refresh');
            }
        });

        $("#btnSearch").click(function () {
            $table.bootstrapTable({ url: pageListUrl });
            $table.bootstrapTable('refresh');
        });

        $("#btnAdd").click(function () {
            $("#crawlModelLabel").html("『" + novelName + "』章节内容抓取");
            $('#crawlModel').modal('toggle'); // 弹出添加窗体            
        });

        GetNovelInfo();

        // 测试抓取
        $("#btnTest").unbind('click').bind('click', function () {

            TestCrawl();

        });

        // 开始抓取
        $("#btnCrawl").unbind('click').bind('click', function () {

            $("#btnCrawl").attr("disabled", "disabled");

            RecursiveCrawl();

        });

        // 清空内容
        $("#btnClear").unbind('click').bind('click', function () {

            $("#txtContent").val("");

        });
    });

    // 测试抓取
    function TestCrawl() {
        
            var chapterUrl = $("#txtChapterUrl").val();
            var contentName = $("#txtContentName").val();
            var headerName = $("#txtHeaderName").val();
            var nextName = $("#txtNextName").val();

            $.ajax({
                url: chapterUrl,
                type: "GET",
                dataType: "html",
                success: function (result) {

                    //正则表达式获取body块  
                    var reg = /<body>[\s\S]*<\/body>/g;
                    var html = reg.exec(result)[0];

                    var $html = $(contentName, $(html));
                    console.log($html);

                    var contents = $("#txtContent").val();

                    var $header = $(headerName, $(html));
                    console.log($header);

                    var txtChapter = $($header).text().trim();

                    // 章节标题修正
                    var chapterReg = /([第]{0,1})([○零一二三四五六七八九十百千\d]{1,})([节章]{0,1}[ ]{0,1}[：:]{0,1})([\s\S]*?)/;
                    txtChapter = txtChapter.replace(chapterReg, "第$2章 $4");

                    //$("#txtChapter").val(txtChapter);

                    contents += txtChapter + "\n";

                    $.each($html, function () {
                        contents += $(this).text().trim() + "\n";
                    });
                    $("#txtContent").val(contents);

                    $nextUrl = $(nextName, $(html));
                    console.log($nextUrl);

                    var nextUrl = $nextUrl[0].href;
                    //var nextUrlTitle = $nextUrl[0].innerText;
                    //$("#txtNextUrl").val(nextUrl);
                    $("#txtChapterUrl").val(nextUrl);

                    // 添加小说内容

                    //var $novelBody = $(".container .novel");
                    //$("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                    //$.each($html, function () {
                    //    $(this).appendTo($novelBody);
                    //});

                    //if (nextUrlTitle.indexOf("下一章") == -1) {
                    //    isEnd = true;
                    //}

                    //RecursiveCrawl(); // 递归查询
                }
            });
    };


    // 递归抓取内容
    function RecursiveCrawl() {

        if (isEnd) return;

        var chapterUrl = $("#txtChapterUrl").val();
        //chapterUrl = encodeURIComponent(chapterUrl);
        var contentName = $("#txtContentName").val();
        var headerName = $("#txtHeaderName").val();
        var nextName = $("#txtNextName").val();

        $.ajax({
            url: chapterUrl,
            type: "GET",
            dataType: "html",
            success: function (result) {

                //正则表达式获取body块  
                var reg = /<body>[\s\S]*<\/body>/g;
                var html = reg.exec(result)[0];

                var $html = $(contentName, $(html));
                //console.log($html);

                var contents = $("#txtContent").val(), content = "";

                var $header = $(headerName, $(html));
                //console.log($header);

                var txtChapter = $($header).text().trim();

                // 章节标题修正
                //var arrTitle = txtChapter.split(" ");
                //var chapterReg = /[第]{0,1}[\s\S]*[章]{0,1}/g;
                //var chapterNum = chapterReg.exec(arrTitle[0])[0];

                //if (arrTitle[0] != "楔子"){
                //    var chapterTitle = arrTitle.length == 1 ? "" : arrTitle[1];
                //    txtChapter = "第" + chapterNum + "章 " + chapterTitle;
                //}

                //debugger;

                var chapterReg = /([第]{0,1})([○零一二三四五六七八九十百千\d]{1,})([节章]{0,1}[ ]{0,1}[：:]{0,1})([\s\S]*?)/;
                txtChapter = txtChapter.replace(chapterReg, "第$2章 $4");

                //var testreg = txtChapter.replace(chapterReg, "$1-$2-$3-$4");

                //$("#txtChapter").val(txtChapter);
                $("#txtChapterTitle").html(txtChapter);

                contents += txtChapter + "\n";

                $.each($html, function () {
                    content += $(this).text().trim() + "\n";
                    contents += $(this).text().trim() + "\n";
                });
                $("#txtContent").val(contents);

                $nextUrl = $(nextName, $(html));
                //console.log($nextUrl);

                var nextUrl = $nextUrl[0].href;
                var nextUrlTitle = $nextUrl[0].innerText;

                $("#txtChapterTitle").val(txtChapter);

                // 添加小说内容
                //var $novelBody = $(".container .novel");
                //$("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                //$.each($html, function () {
                //    $(this).appendTo($novelBody);
                //});

                if (nextUrlTitle.indexOf("下一章") == -1) {
                    isEnd = true;
                }

                // 内容保存
                var params = {
                    NovelId: novelId,
                    ChapterUrl: encodeURIComponent($("#txtChapterUrl").val()),
                    NextUrl: encodeURIComponent(nextUrl),
                    Chapter: encodeURIComponent(txtChapter),
                    Content: encodeURIComponent(content),
                    WordCount: contents.length
                    //,ChapterIndex: 0,
                    //ChapterName: "",
                    //HeadWord: ""
                };

                //SELECT     TOP (200) Id, NovelId, Url, NextUrl, Chapter, ChapterIndex, ChapterName
                //, HeadWord, Content, WordCount, UpdateTime, CreateTime
                //FROM         Chapters

                //$.ajax({
                //    type: "POST",
                //    url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                //    data: params,
                //    success: function (rst) {
                //        if (rst && rst.success) {
                //            $("#txtChapterUrl").val(nextUrl);
                //            RecursiveCrawl(); // 递归抓取内容
                //        } else {
                //            Hsp.Message($(".error-message"), rst.Message, "error", "fade");
                //        }
                //    }
                //});

                $.ajax({
                    url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                    type: 'POST',
                    data: params,
                    success: function (rst) {
                        if (rst && rst.success) {
                            $("#txtChapterUrl").val(nextUrl);
                            RecursiveCrawl(); // 递归抓取内容
                        } else {
                            //debugger;
                            Hsp.Message($(".error-message"), rst.Message, "error", "fade");
                        }
                    },
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

            }
        });
    }

    // 获取小说信息
    function GetNovelInfo() {

        //var novelId = "35986997-DC9D-485B-90CE-DFC754C8669C";

        $.ajax({
            url: '/Handler/WebHandler.ashx?rnd=' + (Math.random() * 16),
            type: 'GET',
            data: { OP: "CRAWL", webId: webId, novelId: novelId },
            success: function (rst) {
                if (rst) {
                    $("#txtChapterUrl").val(rst.NextUrl);
                    $("#txtContentName").val(rst.ContentName);
                    $("#txtHeaderName").val(rst.HeaderName);
                    $("#txtNextName").val(rst.NextName);
                    $("#txtNextTitle").val(rst.NextTitle);
                    $("#txtChapterTitle").html(rst.CurrentChapter);
                }
            },
            complete: function (xhr, errorText, errorType) {
                //debugger;
                //var p = "";
                //alert("请求完成后");
            },
            error: function (xhr, errorText, errorType) {
                alert("请求错误后");
            },
            beforSend: function () {
                alert("请求之前");
            }
        });
    };


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
                    novelId: novelId,
                    qname: $("input[name='search']").val()
                    //,sdate: $("#startDate").val(),
                    //edate: $("#endDate").val()
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

//SELECT     TOP (200) Id, NovelId, Url, NextUrl, Chapter, ChapterIndex, ChapterName
//, HeadWord, Content, WordCount, UpdateTime
//FROM         Chapters

                    {
                        title: '编号',
                        field: 'Id',
                        align: 'center',
                        visible: false,
                        width: 60
                    }, {
                        field: 'Chapter',
                        title: '章节名称',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'Url',
                        title: '地址',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'WordCount',
                        title: '章节字数',
                        width: 105,
                        align: 'center'
                    }, {
                        field: 'UpdateTime',
                        title: '更新时间',
                        width: 105,
                        align: 'center',
                        visible: false,
                        formatter: titleFormatter
                    }, {
                        field: 'CreateTime',
                        title: '添加时间',
                        align: 'center',
                        width: 105,
                        visible: width > Hsp.Mobile.DefaultWidth,
                        formatter: dateFormatter
                    }, {
                        title: '操作',
                        width: 60,
                        align: 'center',
                        events: operateEvents,
                        formatter: operateFormatter
                    }
                ]
            ],
            formatLoadingMessage: function () {
                return "请稍等，正在加载中...";
            },
            formatNoMatches: function () { //没有匹配的结果  
                return '无符合条件的记录';
            },
            onLoadError: function (data) {
                $table.bootstrapTable('removeAll');
            },
            onClickRow: function (row) {
                //alert(row.Id);
                //window.location.href = ""; // "/qStock/qProInfo/" + row.Id;  
            }
        });

        // sometimes footer render error.

        setTimeout(function () {
            $table.bootstrapTable('resetView');
        }, 200);

        $table.on('check.bs.table uncheck.bs.table ' +
            'check-all.bs.table uncheck-all.bs.table', function () {
                $remove.prop('disabled', !$table.bootstrapTable('getSelections').length);

                // save your data, here just save the current page

                selections = getIdSelections();

                // push or splice the selections if you want to save all data selections

            });

        //$table.on('all.bs.table', function(e, name, args) {
        //    console.log(name, args);
        //});

        $remove.click(function () { // 批量删除
            var ids = getIdSelections();
            $table.bootstrapTable('remove', {
                field: 'Id',
                values: ids
            });
            $remove.prop('disabled', true);

            DelWebByIds(ids); // 批量删除
        });

        $(window).resize(function () {
            $table.bootstrapTable('resetView', {
                height: getHeight()
            });
        });
    }


    function getIdSelections() {
        return $.map($table.bootstrapTable('getSelections'), function (row) {
            return row.Id;
        });
    }

    function responseHandler(res) {
        $.each(res.rows, function (i, row) {
            row.state = $.inArray(row.id, selections) !== -1;
        });
        return res;
    }

    // 操作内容格式化
    function operateFormatter(value, row, index) {
        return [
            '<a class="edit" href="javascript:void(0)" title="修改章节">',
            '<i class="glyphicon glyphicon-edit"></i>',
            '</a>  ',
            '<a class="remove" href="javascript:void(0)" title="删除章节">',
            '<i class="glyphicon glyphicon-remove"></i>',
            '</a>'
        ].join('');
    }

    // 操作事件响应
    window.operateEvents = {
        'click .edit': function (e, value, row, index) {
            //alert('You click edit action, row: ' + JSON.stringify(row));

            //$("#txtId").val(row.Id);
            //$("#txtTitle").val(row.Title);
            //$("#txtOldName").val(row.Title);
            //$("#txtExtension").val(row.Extension);
            //$("#txtFullName").val(row.FullName);
            //$("#txtDirectoryName").val(row.DirectoryName);

            $("#editModelLabel").html("章节信息修改");
            $('#editModel').modal('toggle'); // 弹出名称修改

        },
        'click .remove': function (e, value, row, index) {
            $table.bootstrapTable('remove', {
                field: 'Id',
                values: [row.Id]
            });

            DelWebById(row.Id); // 删除行数据，考虑要将上述表格响应纳入到删除操作中
        }
    };

    // 获取内容高度
    function getHeight() {
        return $(window).height() - $('h1').outerHeight(true) - $(".breadcrumb").outerHeight(true) - 36;
    }

    /// <summary>
    /// 删除章节
    /// </summary>

    function DelWebById(id) {
        if (confirm("您确定要删除该章节吗？")) {
            var url = "/Handler/ChapterHandler.ashx?OP=DELETE&ID=" + id;
            $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                if (data && data.success) {
                    modals.correct(data.Message);
                } else {
                    modals.error(data.Message);
                }
            });
        }
    }

    /// <summary>
    /// 批量删除章节
    /// </summary>

    function DelWebByIds(ids) {
        if (confirm("您确定要批量删除这些章节吗？")) {
            var url = "/Handler/ChapterHandler.ashx?OP=BATCHDELETE&IDs=" + ids;
            $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                if (data && data.success) {
                    modals.correct(data.Message);
                } else {
                    modals.error(data.Message);
                }
            });
        }
    }


    $(function () {
        // 模态窗体关闭事件 
        $('#editModel').on('hidden.bs.modal', function () { // 关闭模态窗体事件
            //$("#txtUserId").val("");
            //$("#txtUserCode").val("");
            //$("#txtUserName").val("");
            ////$("#txtMobile").val("");
            ////$("#txtEmail").val("");
            //$("#chbAvailable").removeAttr("checked");

            //var boxes = document.getElementsByName("chbAuthority");
            //for (i = 0; i < boxes.length; i++) {
            //    boxes[i].checked = false;
            //}
        });

        // 数据保存按钮点击事件 
        $("#btnSave").unbind("click").bind("click", function () {

            // RowNumber, UserID, UserCode, UserName, Authority, Available

            var userTypeSum = 0;
            $('input[name="chbAuthority"]:checked').each(function () {
                userTypeSum += parseInt($(this).val());
            });

            var params = {
                id: $("#txtUserId").val(),
                code: $('#txtUserCode').val(),
                name: $("#txtUserName").val(),
                //mobile: $("#txtMobile").val(),
                //email: $('#txtEmail').val(), result-message
                auth: userTypeSum, // 权限
                available: document.getElementById("chbAvailable").checked ? "1" : "0"
            };

            $.ajax({
                type: "POST",
                url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                data: params,
                success: function (rst) {
                    if (rst && rst.success) {

                        Hsp.Message($(".result-message"), rst.Message, "success", "fade");
                        $('#editModel').modal('hide');

                        refreshTable();
                    } else {
                        Hsp.Message($(".error-message"), rst.Message, "error", "fade");
                    }
                }
            });
        });
    });

</script>

</asp:Content>
