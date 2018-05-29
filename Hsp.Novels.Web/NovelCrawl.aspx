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
    <link href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css" rel="stylesheet">

    <!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
    <link href="Scripts/bootstrap/css/ie10-viewport-bug-workaround.css" rel="stylesheet"/>

    <!-- Just for debugging purposes. Don't actually copy these 2 lines! -->
    <!--[if lt IE 9]><script src="/Scripts/ie8-responsive-file-warning.js"></script><![endif]-->
    <script src="/Scripts/ie-emulation-modes-warning.js"></script>

    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
        <script src="https://cdn.bootcss.com/html5shiv/3.7.3/html5shiv.min.js"></script>
        <script src="https://cdn.bootcss.com/respond.js/1.4.2/respond.min.js"></script>
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
            <a class="navbar-brand" href="#" style="padding: 16px 15px;">Haiyu Studio</a>
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
        <%--        <h1>Bootstrap starter template</h1>
        <p class="lead">Use this document as a way to quickly start any new project.<br> All you get is this text and a mostly barebones HTML document.
        </p>--%>

        <form>
            <div class="form-group">
                <label for="txtChapterUrl">Url</label>
                <input type="text" class="form-control" id="txtChapterUrl" placeholder="Url" value="https://www.dashubao.net/book/85/85429/27100366.html">
            </div>
            <div class="form-group">
                <label for="txtContentName">ContentName</label>
                <input type="text" class="form-control" id="txtContentName" placeholder="ContentName" value=".novel .yd_text2 p">
            </div>

            <div class="form-group">
                <label for="txtHeaderName">HeaderName</label>
                <input type="text" class="form-control" id="txtHeaderName" placeholder="HeaderName" value=".novel .oneline">
            </div>
            <div class="form-group">
                <label for="txtNextName">NextName</label>
                <input type="text" class="form-control" id="txtNextName" placeholder="NextName" value=".novel .pereview a:last-child">
            </div>
            
            <div class="form-group">
                <label for="txtContent">Content</label>
                <textarea class="form-control" id="txtContent" placeholder="Content" rows="10"></textarea>
            </div>

            <button type="button" class="btn btn-default">Submit</button>
        </form>


    </div>

</div><!-- /.container -->


<!-- Bootstrap core JavaScript
================================================== -->
<!-- Placed at the end of the document so the pages load faster -->
<script src="https://cdn.bootcss.com/jquery/1.12.4/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src="/Scripts/jquery/jquery-1.12.4.min.js"><\/script>')</script>
<script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<!-- IE10 viewport hack for Surface/desktop Windows 8 bug -->
<script src="/Scripts/ie10-viewport-bug-workaround.js"></script>
    
    <script type="text/javascript">

        $(function() {
            $("form button").unbind('click').bind('click', function () {

                var chapterUrl = $("#txtChapterUrl").val();
                chapterUrl = encodeURIComponent(chapterUrl);
                var contentName = $("#txtContentName").val();
                var headerName = $("#txtHeaderName").val();
                var nextName = $("#txtNextName").val();

                getSource();


                //$.ajax({
                //    url: '/Handler/Handler.ashx?rnd=' + (Math.random() * 16),
                //    type: 'GET',
                //    data: { chapterUrl: chapterUrl, contentName: contentName, headerName: headerName, nextName: nextName },
                //    success: function (rst) {

                //        alert(rst);

                //        //if (rst.IsSuccess) {


                //        //    //$('.Detail-heading').html(rst.Data.ArticleDesc);
                //        //    //$('.detail-article').html(rst.Data.Contents);

                //        //} else {
                //        //    //$.messager.alert({ title: "操作提示", msg: rst.Message, showType: "error" });
                //        //}
                //    }
                //    , complete: function (xhr, errorText, errorType) {

                //        //debugger;
                //        //var p = "";

                //        alert("请求完成后");
                //    }
                //    , error: function(xhr, errorText, errorType) {
                //        alert("请求错误后");
                //    }
                //    , beforSend: function() {
                //        alert("请求之前");
                //    }
                //});


            });
        });

        //用于创建XMLHttpRequest对象 
        function createXmlHttp() {
            //根据window.XMLHttpRequest对象是否存在使用不同的创建方式 
            if (window.XMLHttpRequest) {
                xmlHttp = new XMLHttpRequest(); //FireFox、Opera等浏览器支持的创建方式 
            } else {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");//IE浏览器支持的创建方式 
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

                var obj = $(html);//包装数据  
                //(需要获取的对应块（如class='aa')  
                var $html = $(contentName, obj);
                //console.log($html.html());
                //获取对应块中的内容  
                var value = $html.html();

                document.getElementById("txtContent").value = value;
            }
        }

        $.ajax({
            url: url,
            type: "GET",
            dataType: "html",
            success: function (result) {
                console.log(result);
                var Obj = $("<code></code>").append($(result));//包装数据  
                //(需要获取的对应块（如class='aa')  
                var $html = $(".aa", Obj);
                console.log($html.html());
                //获取对应块中的内容  
                var value = $html.html();
                //获得内容可以用append插入对应的div中，也可以用html（value）直接添加  
            }
        });

        //2，通过正则表达式来实现
        //[plain] view plain copy
        $.ajax({  
            url:url,  
            type:"GET",  
            dataType:"html",  
            success:function(result){  
                console.log(result);  
                //正则表达式获取body块  
                var reg = /[\s\S]*<\/body>/g;  
                var html = reg.exec(result)[0];  
                //然后用filter来筛选对应块对象，如：class='aa'  
                var aa = $(html).filter(".aa");  
                var aahtml = aa.html();  
                console.log(aahtml);  
                //获取内容后可以插入当前html中。。。  
            }  
        });  
        //以上两种方式亲测过可用
        //3，可以通过jquery load()方法中添加标签来获取其中部分加载
        //[plain] view plain copy
        //a1为当前页加载的DIV块，.b为加载html中class=b的块  
        $(".a1").load("userInfo.html .b");  

    </script>
    
    

</body>
</html>