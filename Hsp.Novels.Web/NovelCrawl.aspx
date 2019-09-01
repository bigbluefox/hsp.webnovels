<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NovelCrawl.aspx.cs" Inherits="NovelCrawl" %>

<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!-- 上述3个meta标签*必须*放在最前面，任何其他内容都*必须*跟随其后！ -->
    <meta name="description" content="">
    <meta name="author" content="">

    <title>小说内容抓取</title>

    <!-- Bootstrap core CSS -->
    <link href="/Scripts/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="/Scripts/bootstrap/css/ie10-viewport-bug-workaround.css" rel="stylesheet"/>

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="/Scripts/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="/Scripts/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
        <script src="/Scripts/html5shiv.min.js"></script>
        <script src="/Scripts/respond.min.js"></script>
    <![endif]-->

    <style type="text/css">
          
        body { padding-top: 60px; }

        .navbar-brand { padding: 13px 15px; }

    </style>

</head>

<body>

<nav class="navbar navbar-inverse navbar-fixed-top">
    <div class="container">
        <div class="navbar-header">
            <a class="navbar-brand" href="#">
                <img alt="Brand" src="/Images/brand.png" height="24">
            </a>
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="#" style="padding: 16px 15px;">Haiyu Studio 前端抓取测试</a>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
            <ul class="nav navbar-nav" style="display: none;">
                <li class="active">
                    <a href="#">Home</a>
                </li>
                <li>
                    <a href="#about">About</a>
                </li>
                <li>
                    <a href="#contact">Contact</a>
                </li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</nav>

<div class="container">

    <div class="row">
        <form class="form-horizontal">
            <div class="form-group">
                <label for="txtChapterUrl" class="col-xs-6 col-sm-2 control-label">Url</label>
                <div class="col-xs-6 col-sm-10">
                    <input type="text" class="form-control" id="txtChapterUrl" placeholder="Url" value="https://www.dashubao.net/book/85/85429/27100366.html">
                </div>
            </div>
            <div class="form-group">
                <label for="txtContentName"class="col-xs-6 col-sm-2 control-label">ContentName</label>
                <div class="col-xs-6 col-sm-4">
                    <input type="text" class="form-control" id="txtContentName" placeholder="ContentName" value=".yd_text2 p">
                </div>
                <label for="txtHeaderName" class="col-xs-6 col-sm-2 control-label">HeaderName</label>
                <div class="col-xs-6 col-sm-4">
                    <input type="text" class="form-control" id="txtHeaderName" placeholder="HeaderName" value=".oneline">
                </div>
            </div>
            <div class="form-group">
                <label for="txtNextName"class="col-xs-6 col-sm-2 control-label">NextName</label>
                <div class="col-xs-6 col-sm-4">
                    <input type="text" class="form-control" id="txtNextName" placeholder="NextName" value=".pereview a:last-child">
                </div>
                <label for="txtNextName" class="col-xs-6 col-sm-2 control-label"></label>
                <div class="col-xs-6 col-sm-4">
                    <button type="button" id="btnCrawl" class="btn btn-default">
                        <span class="glyphicon glyphicon-picture" aria-hidden="true"></span> 开始抓取
                    </button>
                    <button type="button" id="btnTest" class="btn btn-default">
                        <span class="glyphicon glyphicon-picture" aria-hidden="true"></span> 测试抓取
                    </button>
                    <input id="txtNextTitle" type="hidden" />
                    <input id="txtUrlCombine" type="hidden" />
                </div>
            </div>
            <div class="form-group">
                <label for="txtTitle"class="col-xs-6 col-sm-2 control-label">Title</label>
                <div class="col-xs-6 col-sm-4">
                    <input type="text" class="form-control" id="txtTitle" placeholder="Title" value="">
                </div>                
                <label for="txtChapter" class="col-xs-6 col-sm-2 control-label">Chapter</label>
                <div class="col-xs-6 col-sm-4">
                    <input type="text" class="form-control" id="txtChapter" placeholder="Title" value="">
                </div>
            </div>
            <div class="form-group">
                <label for="txtContent" class="col-xs-6 col-sm-2 control-label">Content</label>
                <div class="col-xs-6 col-sm-10">
                    <textarea class="form-control" id="txtContent" placeholder="Content" rows="10"></textarea>
                </div>
            </div>
        </form>
    </div>

    <div class="row novel"></div>

</div><!-- /.container -->

<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="/Scripts/jquery/jquery-1.12.4.min.js"><\/script>')</script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="/Scripts/ie10-viewport-bug-workaround.js"></script>
<script src="/Scripts/Hsp.Base.js"></script>

<script type="text/javascript">

    var isEnd = false;

    $(function() {

        // 测试抓取
        $("#btnTest").unbind('click').bind('click', function () {
            var chapterUrl = $("#txtChapterUrl").val();
            var contentName = $("#txtContentName").val();
            var headerName = $("#txtHeaderName").val();
            var nextName = $("#txtNextName").val();
            //var nextTitle = $("#txtNextTitle").val();

            $.ajax({
                url: chapterUrl,
                type: "GET",
                dataType: "html",
                success: function(result) {

                    //正则表达式获取body块  
                    var reg = /<body>[\s\S]*<\/body>/g;
                    var html = reg.exec(result)[0];

                    var $html = $(contentName, $(html));

                    if (window.console && window.console.log) {
                        console.log($html);
                    }

                    var contents = $("#txtContent").val();

                    var $header = $(headerName, $(html));

                    if (window.console && window.console.log) {
                        console.log($header);
                    }

                    var txtChapter = $($header).text().trim();

                    // 章节标题修正
                    var chapterReg = /([第]{0,1})([○零一二三四五六七八九十百千\d]{1,})([节章]{0,1}[ ]{0,1}[：:]{0,1})([\s\S]*?)/;
                    txtChapter = txtChapter.replace(chapterReg, "第$2章 $4");

                    $("#txtChapter").val(txtChapter);

                    contents += txtChapter + "\n";

                    $.each($html, function() {
                        contents += $(this).text().trim() + "\n";
                    });
                    $("#txtContent").val(contents);

                    $nextUrl = $(nextName, $(html));

                    if (window.console && window.console.log) {
                        console.log($nextUrl);
                    }

                    var nextUrl = $nextUrl[0].href;
                    //var nextUrlTitle = $nextNovelWebChapterUrl[0].innerText;
                    //$("#txtNextUrl").val(nextNovelWebChapterUrl);
                    $("#txtChapterUrl").val(nextUrl);

                    // 添加小说内容

                    var $novelBody = $(".container .novel");
                    $("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                    $.each($html, function() {
                        $(this).appendTo($novelBody);
                    });

                    //if (nextUrlTitle.indexOf("下一章") == -1) {
                    //    isEnd = true;
                    //}

                    //RecursiveCrawl(); // 递归查询
                }
            });

        });

        // 开始抓取
        $("#btnCrawl").unbind('click').bind('click', function() {

            recursiveCrawl();

        });

        getNovelInfo();

    });

    // 获取小说信息
    function getNovelInfo() {

        var novelId = "35986997-DC9D-485B-90CE-DFC754C8669C";

        $.ajax({
            url: '/Handler/NovelHandler.ashx?rnd=' + (Math.random() * 16),
            type: 'GET',
            data: { OP: "NOVELLIST", title: "", webId: "", novelId: novelId },
            success: function(rst) {
                if (rst && rst.total > 0) {
                    var novel = rst.rows[0];
                    $("#txtChapterUrl").val(novel.StartUrl);
                    $("#txtContentName").val(novel.ContentName);
                    $("#txtHeaderName").val(novel.HeaderName);
                    $("#txtNextName").val(novel.NextName);
                    $("#txtNextTitle").val(novel.NextTitle);

                    $("#txtTitle").val(novel.Title);

                    //alert(novel.NextTitle); // txtTitle
                }
            },
            complete: function(xhr, errorText, errorType) {
                //debugger;
                //var p = "";
                //alert("请求完成后");
            },
            error: function (xhr, errorText, errorType) {
                alert("请求错误后");
            },
            beforSend: function() {
                alert("请求之前");
            }
        });
    };


    // 递归抓取内容
    function recursiveCrawl() {

        if (isEnd) return;

        var chapterUrl = $("#txtChapterUrl").val();
        //chapterUrl = encodeURIComponent(chapterNovelWebChapterUrl);
        var contentName = $("#txtContentName").val();
        var headerName = $("#txtHeaderName").val();
        var nextName = $("#txtNextName").val();

        $.ajax({
            url: chapterUrl,
            type: "GET",
            dataType: "html",
            success: function(result) {

                //正则表达式获取body块  
                var reg = /<body>[\s\S]*<\/body>/g;
                var html = reg.exec(result)[0];

                var $html = $(contentName, $(html));

                if (window.console && window.console.log) {
                    console.log($html);
                }

                var contents = $("#txtContent").val();

                var $header = $(headerName, $(html));

                if (window.console && window.console.log) {
                    console.log($header);
                }

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

                $("#txtChapter").val(txtChapter);

                contents += txtChapter + "\n";

                $.each($html, function() {
                    contents += $(this).text().trim() + "\n";
                });
                $("#txtContent").val(contents);

                $nextUrl = $(nextName, $(html));

                if (window.console && window.console.log) {
                    console.log($nextUrl);
                }

                var nextUrl = $nextUrl[0].href;
                var nextUrlTitle = $nextUrl[0].innerText;
                //$("#txtNextUrl").val(nextNovelWebChapterUrl);
                $("#txtChapterUrl").val(nextUrl);


                // 添加小说内容

                var $novelBody = $(".container .novel");
                $("<h1>" + txtChapter + "</h1>").appendTo($novelBody);
                $.each($html, function() {
                    $(this).appendTo($novelBody);
                });

                if (nextUrlTitle.indexOf("下一章") == -1) {
                    isEnd = true;
                }

                recursiveCrawl(); // 递归查询
            }
        });
    }


    //用于创建XMLHttpRequest对象 
    function createXmlHttp() {
        //根据window.XMLHttpRequest对象是否存在使用不同的创建方式 
        if (window.XMLHttpRequest) {
            xmlHttp = new XMLHttpRequest(); //FireFox、Opera等浏览器支持的创建方式 
        } else {
            xmlHttp = new ActiveXObject("Microsoft.XMLHTTP"); //IE浏览器支持的创建方式 
        }
    }

    //直接通过XMLHttpRequest对象获取远程网页源代码 
    function getSource() {
        var url = document.getElementById("txtChapterUrl").value; //获取目标地址信息 
        //地址为空时提示用户输入 
        if (url == "") {
            alert("请输入网页地址。");
            return;
        }
        document.getElementById("txtContent").value = "正在加载……"; //提示正在加载 
        createXmlHttp(); //创建XMLHttpRequest对象 
        xmlHttp.onreadystatechange = writeSource; //设置回调函数 
        xmlHttp.open("GET", url, true);
        xmlHttp.send(null);
    }

    //将远程网页源代码写入页面文字区域 
    function writeSource() {
        if (xmlHttp.readyState == 4) {

            var contentName = $("#txtContentName").val();

            var html = xmlHttp.responseText;

            var obj = $(html); //包装数据  
            //(需要获取的对应块（如class='aa')  
            var $html = $(contentName, obj);
            //console.log($html.html());
            //获取对应块中的内容  
            var value = $html.html();

            document.getElementById("txtContent").value = value;
        }
    }

    //$.ajax({
    //    url: url,
    //    type: "GET",
    //    dataType: "html",
    //    success: function (result) {
    //        console.log(result);
    //        var Obj = $("<code></code>").append($(result));//包装数据  
    //        //(需要获取的对应块（如class='aa')  
    //        var $html = $(".aa", Obj);
    //        console.log($html.html());
    //        //获取对应块中的内容  
    //        var value = $html.html();
    //        //获得内容可以用append插入对应的div中，也可以用html（value）直接添加  
    //    }
    //});

    //2，通过正则表达式来实现
    //[plain] view plain copy
    //$.ajax({  
    //    url:url,  
    //    type:"GET",  
    //    dataType:"html",  
    //    success:function(result){  
    //        console.log(result);  
    //        //正则表达式获取body块  
    //        var reg = /[\s\S]*<\/body>/g;  
    //        var html = reg.exec(result)[0];  
    //        //然后用filter来筛选对应块对象，如：class='aa'  
    //        var aa = $(html).filter(".aa");  
    //        var aahtml = aa.html();  
    //        console.log(aahtml);  
    //        //获取内容后可以插入当前html中。。。  
    //    }  
    //});  

    //以上两种方式亲测过可用
    //3，可以通过jquery load()方法中添加标签来获取其中部分加载
    //[plain] view plain copy
    //a1为当前页加载的DIV块，.b为加载html中class=b的块  
    //$(".a1").load("userInfo.html .b");  

</script>

</body>
</html>