<%@ Page Title="" Language="C#" MasterPageFile="~/PageMaster/BootStrap.master" AutoEventWireup="true" CodeFile="Chapter.aspx.cs" Inherits="Chapter" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" Runat="Server">
    章节管理
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" Runat="Server">

    <link href="/Scripts/bootstrap/css/bootstrap-table.min.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-validator.css" rel="stylesheet"/>
    <link href="/Styles/Hsp.Base.css" rel="stylesheet"/>

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

         .error-message{ padding: 0 15px;}
         .alert{ margin-bottom: 0;}
         /*.modal-body{ padding-bottom: 0;}*/
    </style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContainerContent" Runat="Server">

    <%--<h3 class="page-header">章节管理</h3>--%>
    
    <div class="result-message"></div>

<%--    <ol class="breadcrumb">
        <li>
            <a href="/Default.aspx">站点管理</a>
        </li>
        <li>
            <a href="/Novel.aspx?webId=<% = WebId %>&webName=<% = HttpUtility.UrlEncode(WebName)%>"><% = WebName %></a>
        </li>        
        <li class="active"><% = NovelName %></li>
    </ol>--%>
    
    <div class="page-header" style="display: block;">
        <h2 class="pull-left">
            <i class="fa fa-address-card-o"></i>
            <span>章节管理</span>
        </h2>
        <div class="pull-right">
            <ul class="breadcrumb">
                <li>
                    <a href="/Default.aspx"><i class="glyphicon glyphicon-home"></i>首页</a>
                </li>
                <li class="separator">
                    <i class="fa fa-angle-right"></i>
                </li>
                <li>
                    <a href="/Novel.aspx?webId=<% = WebId %>&webName=<% = HttpUtility.UrlEncode(WebName)%>"><% = WebName %></a>
                </li>
                <li class="separator">
                    <i class="fa fa-angle-right"></i>
                </li>
                <li class="active">章节管理</li>
            </ul>
        </div>
    </div>

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
            <button id="btnAdd" class="btn btn-primary" style="display: none;">
                <i class="glyphicon icon-folder-plus"></i> 获取章节
            </button>
            <button id="btnCrawlContent" class="btn btn-primary">
                <i class="glyphicon icon-folder-plus"></i> 抓取内容
            </button>
             <button id="btnClearContent" class="btn btn-primary">
                <i class="glyphicon icon-folder-plus"></i> 清空内容
            </button>           
            <button id="btnClearNovelData" class="btn btn-primary">
                <i class="glyphicon icon-folder-plus"></i> 清空数据
            </button>
        </div>
    </div>
    
    <table id="chapter-table" data-mobile-responsive="true" data-toggle="table"></table>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ModalContent" Runat="Server">
    
    <div class="modal fade" id="crawlModel" tabindex="-1" role="dialog" aria-labelledby="crawlModelLabel">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="crawlModelLabel">小说章节获取</h4>
                </div>
                <div class="modal-body">

                    <form class="form-horizontal">
                        <div class="form-group">
                            <label for="txtChapterUrl" class="col-xs-3 col-sm-2 control-label">起始地址</label>
                            <div class="col-xs-9 col-sm-6">
                                <input type="text" class="form-control" id="txtChapterUrl" placeholder="起始地址" value="https://www.dashubao.net/book/85/85429/27100366.html">
                            </div>
                            <label for="txtChapterChar" class="col-xs-3 col-sm-2 control-label">章节模板</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtChapterChar" placeholder="章节模板" value="第$2章">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtContentName" class="col-xs-3 col-sm-2 control-label">内容对象</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtContentName" placeholder="内容对象" value=".yd_text2 p">
                            </div>
                            <label for="txtHeaderName" class="col-xs-3 col-sm-2 control-label">标题对象</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtHeaderName" placeholder="标题对象" value=".oneline">
                            </div>
                            <label for="txtStartChapterIdx" class="col-xs-3 col-sm-2 control-label">起始数字</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtStartChapterIdx" placeholder="起始数字" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtNextName" class="col-xs-3 col-sm-2 control-label">地址对象</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtNextName" placeholder="下一章地址对象" value=".pereview a:last-child">
                            </div>
                            <label for="txtNextTitle" class="col-xs-3 col-sm-2 control-label">结束标识</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtNextTitle" placeholder="结束标识不含" value="">
                            </div> 
                            <label for="txtChapterType" class="col-xs-3 col-sm-2 control-label">标题处理</label>
                            <div class="col-xs-9 col-sm-2">
                                <input type="text" class="form-control" id="txtChapterType" placeholder="标题处理" value="">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="txtContent" class="col-xs-3 col-sm-2 control-label">小说内容</label>
                            <div class="col-xs-9 col-sm-10">
                                <textarea class="form-control" id="txtContent" placeholder="抓取小说内容" rows="10"></textarea>
                            </div>
                        </div>
                        <div class="form-group" style="padding-bottom: -15px;">
                            <div>
                                <div class="error-message"></div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <input id="txtNextUrl" type="hidden" />
                    <input id="txtHeadWord" type="hidden" />
                    <input id="txtUrlCombine" type="hidden" />
                    <input id="txtNovelUrl" type="hidden" />
                    <input id="txtWebUrl" type="hidden" />
                    <input id="txtNovelTitle" type="hidden" />
                    
                    <input id="txtAnnotationType" type="hidden" />
                    <input id="txtLineSign" type="hidden" />                    

                    <div style="float: left;" id="txtChapterTitle"></div>
                    <button type="button" class="btn btn-default" data-dismiss="modal">
                        <span class="glyphicon glyphicon-floppy-remove" aria-hidden="true"></span> 关闭
                    </button>
                    <button type="button" class="btn btn-primary" id="btnClear">
                        <span class="glyphicon glyphicon-floppy-saved" aria-hidden="true"></span> 清空
                    </button>
                    <button type="button" class="btn btn-primary" id="btnLastChapter">
                        <span class="glyphicon glyphicon-refresh" aria-hidden="true"></span> 末章继续
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
                            <label for="txtChapterName">章节标题<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtChapterName" placeholder="章节标题" required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtChapterContent">章节内容</label>
                            <textarea class="form-control" id="txtChapterContent" rows="10"></textarea>
                        </div>
                        
                    <%--SELECT     TOP (200) Id, NovelId, ChapterUrl, NextUrl, Chapter
                    , ChapterIdx, ChapterName, HeadWord, [Content], WordCount, UpdateTime, CreateTime
                    FROM         Chapters--%>
                        <div class="form-group">
                            <label for="selValidChapter">章节状态</label>
                            <select class="form-control" id="selValidChapter">
                              <option value="0">无效</option>
                              <option value="1" selected="selected">有效</option>
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
                    <input type="hidden" id="txtChapterId">
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

<script src="/Scripts/Hsp.Base.js"></script>
<script src="/Scripts/Hsp.Formater.js"></script>
<script src="/Scripts/Hsp.Common.js"></script>
<script src="/Scripts/Hsp.Modal.js"></script>

<script type="text/javascript">

    var $table = $('#chapter-table'),
        $remove = $('#remove'),
        selections = [],
        key = 'Id';

    var pageNumber = 1, width = 0, isEnd = false;
    var webId = "<% = WebId %>", novelId = "<% = NovelId %>", novelName = "<% = NovelName %>";
    var pageListUrl = "/Handler/ChapterHandler.ashx?OP=LIST";
    var circleModalId = "circleModal", $circleModal = null; // 圆形进度条窗体及对象

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

        //GetNovelInfo(); // 章节处理参数

        // 测试抓取
        $("#btnTest").unbind('click').bind('click', function () {

            //TestCrawl();
            RecursiveCrawl(true);

        });

        // 开始抓取
        $("#btnCrawl").unbind('click').bind('click', function () {

            $("#btnCrawl").attr("disabled", "disabled");

            RecursiveCrawl(false);

        });

        // 清空内容
        $("#btnClear").unbind('click').bind('click', function () {

            $("#txtContent").val("");

        });

        // 更新读取的末章地址信息，以方便继续文章处理
        $("#btnLastChapter").unbind('click').bind('click', function () {

            alert("更新读取的末章地址信息，以方便继续文章处理");

        });

        // 抓取小说内容
        $("#btnCrawlContent").unbind('click').bind('click', function () {

            Hsp.Modal.CircleMessage(circleModalId, "操作进行中...");
            $("#" + circleModalId).modal("toggle");

            //setTimeout(function () {
            //    $("#" + circleModalId).modal("hide");
            //}, 5000); webId

            var url = "/Handler/ChapterHandler.ashx?OP=CRAWLCONTENT&webId=" + webId + "&novelId=" + novelId;

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

        // 清空小说内容
        $("#btnClearContent").unbind('click').bind('click', function () {

            if (confirm("您确定要清空小说内容吗？")) {
                var url = "/Handler/ChapterHandler.ashx?OP=CLEARCONTENT&ID=" + novelId + "&name=" + novelName;
                $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                    if (data && data.success) {
                        modals.correct(data.Message);
                    } else {
                        modals.error(data.Message ? data.Message : "删除章节错误");
                    }
                });
            }
        });

        // 清空小说数据
        $("#btnClearNovelData").unbind('click').bind('click', function () {

            if (confirm("您确定要清空小说数据吗？")) {
                var url = "/Handler/ChapterHandler.ashx?OP=CLEARDATA&ID=" + novelId + "&name=" + novelName;
                $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                    if (data && data.success) {
                        modals.correct(data.Message);
                    } else {
                        modals.error(data.Message ? data.Message : "删除章节错误");
                    }
                });
            }
        });

    });

    // 章节标题处理
    function ChapterTitle(chapter, type) {

        // 章节标题修正
        var chapterChar = $("#txtChapterChar").val();
        if (chapterChar.length == 0) chapterChar = "第$2章";
        var chapterReg = /([第]{0,1})([○零一二三四五六七八九十百千\d]{1,})([节章]{0,1}[ ]{0,1}[：:]{0,1})([\s\S]*?)/;
        //var txtChapter = chapter.replace(chapterReg, "第$2章 $4");
        var txtChapter = chapter.replace(chapterReg, chapterChar + " $4");

        var chapters = chapter.replace(chapterReg, "$1,$2,$3,$4");
        var arr = chapters.split(',');

        if (arr.length == 4 && arr[2].length == 0) {
            if (txtChapter.indexOf("楔子") == -1) {
                return "";
            }
        } // 空章节序号，

        if (type == 1) { // 标题出现重复

            var chapterIdx = arr[1];
            //var chapterName = "第" + chapterIdx + "章";
            var chapterName = chapterChar.replace("$2", chapterIdx); // "第" + chapterIdx + "章";
            var headWord = arr[3].replace(chapterName, "");
            //headWord = headWord.replace(".", "").replace(" ", "");

            headWord = headWord.trim('[.]').trim(' ');

            //alert(chapterName + " * " + headWord);

            chapterIdx = chapterIdx.lTrim('0').lTrim('0');
            //txtChapter = "第" + chapterIdx + "章 " + headWord;

            txtChapter = chapterChar.replace("$2", chapterIdx) + " " + headWord;
        }

        // 处理标题括号

        //debugger;

        //https://www.dashubao.net/book/91/91196/31005369.html
        //    第10章 超级步枪（4）（求推荐） 第6章 女上尉（求收藏）

        var bracketsReg = /([\s\S]*?)([(（][^\)）]*([\s\S]*?)[)）])/g;
        var matchResult = txtChapter.match(bracketsReg);
        txtChapter = matchResult == null ? txtChapter : matchResult[0];

        var title = txtChapter.replace(bracketsReg, "$1,$2");
        var titleArr = title.split(',');

        if (titleArr.length > 1 && titleArr[1].length > 3) {
            txtChapter = titleArr[0];
        }

        // 处理标题包含小说名称问题
        var novelTitle = $("#txtNovelTitle").val();
        txtChapter = txtChapter.replace(novelTitle, "");
        txtChapter = txtChapter.trim();

        return txtChapter;
    }

    // 测试抓取 (废弃)
    function TestCrawl() {

        var chapterUrl = $("#txtChapterUrl").val();
        var contentName = $("#txtContentName").val();
        var headerName = $("#txtHeaderName").val();
        var nextName = $("#txtNextName").val();
        var startChapterIdx = $("#txtStartChapterIdx").val();
        var chapterType = $("#txtChapterType").val();

        var urlCombine = $("#txtUrlCombine").val();
        var webUrl = $("#txtWebUrl").val();
        var novelUrl = $("#txtNovelUrl").val();

        var annotationType = $("#txtAnnotationType").val(); // 正文类型：0-文本，1-HTML
        var lineSign = $("#txtLineSign").val(); // 换行标识：无，<br><br>　

        if (urlCombine == "1") { // 地址是否需要组合？1-网站+章节地址
            chapterUrl = chapterUrl.replace(webUrl, "");
            if (chapterUrl.startWith('/')) chapterUrl = chapterUrl.lTrim('/');
            if (!webUrl.endWith('/')) webUrl = webUrl + '/';
            chapterUrl = webUrl + chapterUrl;
        }
        if (urlCombine == "2") { // 地址是否需要组合？2-小说+章节地址
            chapterUrl = chapterUrl.replace(novelUrl, "");
            if (chapterUrl.startWith('/')) chapterUrl = chapterUrl.lTrim('/');
            if (!webUrl.endWith('/')) webUrl = webUrl + '/';
            chapterUrl = novelUrl + chapterUrl;
        }

        $.ajax({
            url: chapterUrl,
            type: "GET",
            dataType: "html",
            success: function (result) {

                //debugger;

                //正则表达式获取body块  
                var reg = /<body[\s\S]*<\/body>/g;
                var htm = reg.exec(result);
                var html = htm.length > 0 ? htm[0] : "";// reg.exec(result)[0];

                var $html = $(contentName, $(html));
                //console.log($html);

                var contents = $("#txtContent").val();

                var $header = $(headerName, $(html));
                //console.log($header);

                var txtChapter = $($header).text().trim();
                txtChapter = ChapterTitle(txtChapter, chapterType);

                //$("#txtChapter").val(txtChapter);

                if (txtChapter.length > 0) {
                    $("#txtChapterTitle").html(txtChapter);
                    contents += txtChapter + "\n";

                    if (annotationType == "0") { // 文本
                        $.each($html, function() {
                            contents += $(this).text().trim() + "\n";
                        });
                    }
                    if (annotationType == "1") { // HTML
                        var $innerHtml = $html[0].innerHTML;
                        var lineReg = new RegExp(lineSign, "gi");
                        contents += $innerHtml.replace(lineReg, "\n");

                        var replaceReg = new RegExp("[Pp][Ss][\d]?[:：].*", "gi");
                        contents = contents.replace(replaceReg, "");
                    }

                    $("#txtContent").val(contents);
                } else {
                    Hsp.Common.Message($(".error-message"), "章节标题为空！", "warning", "fade");
                }

                $nextUrl = $(nextName, $(html));
                //console.log($nextChapterUrl);

                var nextUrl = $nextUrl[0].href;

                if (urlCombine != "0") {
                    var local = window.location.protocol + "//" + window.location.host;
                    nextUrl = nextUrl.replace(local, "");
                }

                //var nextChapterUrlTitle = $nextNovelWebChapterUrl[0].innerText;
                //$("#txtNextChapterUrl").val(nextNovelWebChapterUrl);

                $("#txtChapterUrl").val(nextUrl);
                $("#txtStartChapterIdx").val(parseInt(startChapterIdx) + 1); // 起始/当前章节数字


                // 添加小说内容

                //var $novelBody = $(".container .novel");
                //$("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                //$.each($html, function () {
                //    $(this).appendTo($novelBody);
                //});

                //if (nextChapterUrlTitle.indexOf("下一章") == -1) {
                //    isEnd = true;
                //}

                //RecursiveCrawl(); // 递归查询
            }
        });
    };
    
    // 递归抓取内容
    function RecursiveCrawl(test) {

        if (isEnd) return;

        var chapterUrl = $("#txtChapterUrl").val();
        var contentName = $("#txtContentName").val();
        var headerName = $("#txtHeaderName").val();
        var nextName = $("#txtNextName").val();
        var chapterChar = $("#txtChapterChar").val();
        var startChapterIdx = $("#txtStartChapterIdx").val();
        var chapterType = $("#txtChapterType").val();

        var urlCombine = $("#txtUrlCombine").val();
        var webUrl = $("#txtWebUrl").val();
        var novelUrl = $("#txtNovelUrl").val();

        var annotationType = $("#txtAnnotationType").val(); // 正文类型：0-文本，1-HTML
        var lineSign = $("#txtLineSign").val(); // 换行标识：无，<br><br>　

        if (urlCombine == "1") { // 地址是否需要组合？1-网站+章节地址
            chapterUrl = chapterUrl.replace(webUrl, "");
            if (chapterUrl.startWith('/')) chapterUrl = chapterUrl.lTrim('/');
            if (!webUrl.endWith('/')) webUrl = webUrl + '/';
            chapterUrl = webUrl + chapterUrl;
        }
        if (urlCombine == "2") { // 地址是否需要组合？2-小说+章节地址
            chapterUrl = chapterUrl.replace(novelUrl, "");
            if (chapterUrl.startWith('/')) chapterUrl = chapterUrl.lTrim('/');
            if (!webUrl.endWith('/')) webUrl = webUrl + '/';
            chapterUrl = novelUrl + chapterUrl;
        }

        //debugger;

        $.ajax({
            url: chapterUrl,
            type: "GET",
            dataType: "html",
            crossDomain: true,
            success: function (result) {

                //正则表达式获取body块  
                var reg = /<body[\s\S]*<\/body>/g;
                var html = reg.exec(result)[0];

                var $html = $(contentName, $(html));

                if (window.console && window.console.log) {
                    console.log($html);
                }

                var contents = $("#txtContent").val(), content = "";

                var $header = $(headerName, $(html));

                if (window.console && window.console.log) {
                    console.log($header);
                }

                var txtChapter = $($header).text().trim();
                txtChapter = ChapterTitle(txtChapter, chapterType);

                // 章节标题修正
                //var arrTitle = txtChapter.split(" ");
                //var chapterReg = /[第]{0,1}[\s\S]*[章]{0,1}/g;
                //var chapterNum = chapterReg.exec(arrTitle[0])[0];

                //if (arrTitle[0] != "楔子"){
                //    var chapterTitle = arrTitle.length == 1 ? "" : arrTitle[1];
                //    txtChapter = "第" + chapterNum + "章 " + chapterTitle;
                //}

                //debugger;

                //var chapterReg = /([第]{0,1})([○零一二三四五六七八九十百千\d]{1,})([节章]{0,1}[ ]{0,1}[：:]{0,1})([\s\S]*?)/;
                //txtChapter = txtChapter.replace(chapterReg, chapterChar + " $4");
                //txtChapter = ChapterTitle(txtChapter, chapterType);

                //var testreg = txtChapter.replace(chapterReg, "$1-$2-$3-$4");
                //$("#txtChapter").val(txtChapter);

                if (txtChapter.length > 0) {
                    $("#txtChapterTitle").html(txtChapter);
                    contents += txtChapter + "\n";

                    if (annotationType == "0") { // 文本
                        $.each($html, function () {
                            content += $(this).text().trim() + "\n";
                            contents += $(this).text().trim() + "\n";
                        });
                    }
                    if (annotationType == "1") { // HTML
                        var $innerHtml = $html[0].innerHTML;
                        var lineReg = new RegExp(lineSign, "gi");
                        contents += $innerHtml.replace(lineReg, "\n");

                        var replaceReg = new RegExp("[Pp][Ss][\d]?[:：].*", "gi");
                        contents = contents.replace(replaceReg, "");
                    }

                    $("#txtContent").val(contents);

                } else {
                    Hsp.Common.Message($(".error-message"), "章节标题为空！", "error", "fade");
                }

                $nextUrl = $(nextName, $(html));
                //console.log($nextChapterUrl);

                var nextUrl = $nextUrl[0].href;
                if (urlCombine != "0") {
                    var local = window.location.protocol + "//" + window.location.host;
                    nextUrl = nextUrl.replace(local, "");
                }
                var nextUrlTitle = $nextUrl[0].innerText;
                $("#txtStartChapterIdx").val(parseInt(startChapterIdx) + 1); // 起始/当前章节数字

                //$("#txtChapterTitle").val(txtChapter);

                // 添加小说内容
                //var $novelBody = $(".container .novel");
                //$("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                //$.each($html, function () {
                //    $(this).appendTo($novelBody);
                //});

                if (nextUrlTitle.indexOf("下一章") == -1) {
                    isEnd = true;
                }

                // 标题为空，则不记录
                if (txtChapter.length == 0) {
                    $("#txtChapterUrl").val(nextUrl);
                    RecursiveCrawl(); // 递归抓取内容
                    return;
                }

                if (test) return;

                // 内容保存
                var params = {
                    NovelId: novelId,
                    ChapterUrl: encodeURIComponent($("#txtChapterUrl").val()),
                    NextUrl: encodeURIComponent(nextUrl),
                    Chapter: encodeURIComponent(txtChapter),
                    Content: encodeURIComponent(content),
                    WordCount: contents.length,
                    ChapterIdx: $("#txtStartChapterIdx").val()
                    //,ChapterName: "", //HeadWord: ""
                };

                //SELECT     TOP (200) Id, NovelId, ChapterUrl, NextNovelWebChapterUrl, Chapter, ChapterIdx, ChapterName
                //, HeadWord, Content, WordCount, UpdateTime, CreateTime
                //FROM         Chapters

                $.ajax({
                    type: "POST",
                    url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                    data: params,
                    success: function (rst) {
                        if (rst && rst.success) {

                            //debugger;

                            $("#txtChapterUrl").val(nextUrl);
                            RecursiveCrawl(false); // 递归抓取内容
                        } else {
                            if (rst.Message) {
                                Hsp.Common.Message($(".error-message"), rst.Message, "error");
                            } else {
                                Hsp.Common.Message($(".error-message"), "章节数据保存失败！", "error");
                            }
                        }
                    }
                });

                //$.ajax({
                //    url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                //    type: 'POST',
                //    data: params,
                //    success: function (rst) {
                //        if (rst && rst.success) {
                //            $("#txtChapterChapterUrl").val(nextNovelWebChapterUrl);
                //            RecursiveCrawl(); // 递归抓取内容
                //        } else {
                //            //debugger;
                //            Hsp.Message($(".error-message"), rst.Message, "error", "fade");
                //        }
                //    },
                //    complete: function (xhr, errorText, errorType) {
                //        //debugger;
                //        //var p = "";
                //        //alert("请求完成后");
                //    },
                //    error: function (xhr, errorText, errorType) {
                //        debugger;
                //        alert("请求错误后");
                //    },
                //    beforSend: function () {
                //        alert("请求之前");
                //    }
                //});

            }
        });
    }

    // 获取小说信息
    function GetNovelInfo() {
        $.ajax({
            url: '/Handler/NovelHandler.ashx?rnd=' + (Math.random() * 16),
            type: 'GET',
            data: { OP: "CRAWL", webId: webId, novelId: novelId },
            success: function (rst) {

                if (window.console && window.console.log) {
                    console.log(rst);
                }

                if (rst) {
                    $("#txtChapterUrl").val(rst.NextUrl);
                    $("#txtContentName").val(rst.ContentName);
                    $("#txtHeaderName").val(rst.HeaderName);
                    $("#txtNextName").val(rst.NextName);
                    $("#txtNextTitle").val(rst.NextTitle);
                    $("#txtChapterTitle").html(rst.CurrentChapter);

                    $("#txtChapterChar").val(rst.ChapterChar);
                    $("#txtStartChapterIdx").val(rst.StartChapterIdx);
                    $("#txtChapterType").val(rst.ChapterType);
                    $("#txtUrlCombine").val(rst.UrlCombine);

                    $("#txtWebUrl").val(rst.WebUrl);
                    $("#txtNovelUrl").val(rst.NovelUrl);
                    $("#txtNovelTitle").val(rst.Title);

                    $("#txtAnnotationType").val(rst.AnnotationType);
                    $("#txtLineSign").val(rst.LineSign);

                    // , AnnotationType, LineSign
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

//SELECT     TOP (200) Id, NovelId, ChapterUrl, NextNovelWebChapterUrl, Chapter, ChapterIdx, ChapterName
//, HeadWord, Content, WordCount, UpdateTime
//FROM         Chapters

                    {
                        title: '编号',
                        field: 'Id',
                        align: 'center',
                        visible: false,
                        width: 60
                    }, {
                        field: 'ChapterIdx',
                        title: '章节序号',
                        halign: 'center',
                        align: 'center',
                        width: 90
                    }, {
                        field: 'Chapter',
                        title: '章节名称',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'ChapterUrl',
                        title: '地址',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'WordCount',
                        title: '章节字数',
                        width: 90,
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
                        width: 75,
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

            DelChapterByIds(ids); // 批量删除
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

            $("#txtChapterId").val(row.Id);
            $("#txtChapterName").val(row.Chapter);
            $("#txtChapterContent").val(row.Content);
            $("#selValidChapter").val(row.ValidChapter);

            $("#editModelLabel").html("章节信息修改");
            $('#editModel').modal('toggle'); // 弹出名称修改

        },
        'click .remove': function (e, value, row, index) {
            $table.bootstrapTable('remove', {
                field: 'Id',
                values: [row.Id]
            });

            DelChapterById(row.Id); // 删除行数据，考虑要将上述表格响应纳入到删除操作中
        }
    };

    // 获取内容高度
    function getHeight() {
        return $(window).height() - $(".page-header").outerHeight(true); // $('h1').outerHeight(true) - $(".breadcrumb").outerHeight(true) - 36;
    }

    /// <summary>
    /// 删除章节
    /// </summary>

    function DelChapterById(id) {
        if (confirm("您确定要删除该章节吗？")) {
            var url = "/Handler/ChapterHandler.ashx?OP=DELETE&ID=" + id;
            $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                if (data && data.success) {
                    modals.correct(data.Message);
                } else {
                    modals.error(data.Message ? data.Message : "删除章节错误");
                }
            });
        }
    }

    /// <summary>
    /// 批量删除章节
    /// </summary>

    function DelChapterByIds(ids) {
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
            $("#txtChapterId").val("");
            $("#txtChapterName").val("");
            $("#txtChapterContent").val("");
        });

        // 数据保存按钮点击事件 
        $("#btnSave").unbind("click").bind("click", function () {

            var params = {
                id: $("#txtChapterId").val(),
                chapter: $('#txtChapterName').val(),
                content: $("#txtChapterContent").val(),
                validChapter: $("#selValidChapter").val()
            };

            $.ajax({
                type: "POST",
                url: "/Handler/ChapterHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
                data: params,
                success: function (rst) {
                    if (rst && rst.success) {

                        Hsp.Common.Message($(".result-message"), rst.Message, "success", "fade");
                        $('#editModel').modal('hide');

                        refreshTable();
                    } else {
                        Hsp.Common.Message($(".error-message"), rst.Message, "error", "fade");
                    }
                }
            });
        });
    });

</script>

</asp:Content>
