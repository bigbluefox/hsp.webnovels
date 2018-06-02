<%@ Page Title="" Language="C#" MasterPageFile="~/PageMaster/BootStrap.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" Runat="Server">
    站点列表
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" Runat="Server">
    
    <link href="/Scripts/bootstrap/css/bootstrap-table.min.css" rel="stylesheet" />
    <link href="/Scripts/bootstrap/css/bootstrap-validator.css" rel="stylesheet" />
    <link href="/Scripts/bootstrap/css/bootstrap-datetimepicker.min.css" rel="stylesheet"/>

    <style type="text/css"></style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContainerContent" Runat="Server">
    
     <h3 class="page-header">站点管理</h3>

    <ol class="breadcrumb">
        <li>
            <a href="/Default.aspx">首页</a>
        </li>
        <li class="active">站点管理</li>
    </ol>

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
        </div>
    </div>

    <table id="log-table" data-mobile-responsive="true" data-toggle="table" ></table>   

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ModalContent" Runat="Server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="SubScriptContent" Runat="Server">
    
    <script src="Scripts/bootstrap/js/bootstrap-table.min.js"></script>
<script src="/Scripts/bootstrap/js/locales/bootstrap-table-zh-CN.js"></script>
    <script src="Scripts/bootstrap/js/bootstrap-validator.min.js"></script> 
    <script src="Scripts/bootstrap/js/locales/bootstrap-validator-zh-CN.js"></script>
<script src="/Scripts/bootstrap/js/bootstrap-datetimepicker.min.js"></script>
<script src="/Scripts/bootstrap/js/locales/bootstrap-datetimepicker.zh-CN.js"></script>
    <script src="Scripts/Hsp.Formater.js"></script> 

    <script type="text/javascript">

        var $table = $('#log-table'),
            $remove = $('#remove'),
            selections = [],
            key = 'Id';

        var pageNumber = 1, width = 0;
        var pageListUrl = "/Handler/WebHandler.ashx?OP=LIST";

        $(function() {

            width = Hsp.Common.AvailWidth();

            $table = $('#log-table'),
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
        });


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

//SELECT     TOP (200) Id, Name, Url, Valid
//, ContentName, HeaderName, NextName, NextTitle, CreateTime，ChildNodeCount
//FROM         WebSites

                        {
                            title: '编号',
                            field: 'Id',
                            align: 'center',
                            visible: width > Hsp.Mobile.QuartWidth,
                            width: 60
                        }, {
                            field: 'Name',
                            title: '站点名称',
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
                            field: 'ContentName',
                            title: '内容类名',
                            width: 75,
                            align: 'center'
                        }, {
                            field: 'ChildNodeCount',
                            title: '子项数量',
                            halign: 'center',
                            align: 'left',
                            visible: width > Hsp.Mobile.DefaultWidth,
                            formatter: titleFormatter
                        }, {
                            field: 'CreateTime',
                            title: '添加时间',
                            align: 'center',
                            width: 90,
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
                //'<a class="like" href="javascript:void(0)" title="播放">',
                //'<i class="glyphicon glyphicon-play"></i>',
                //'</a>  ',
                //'<a class="edit" href="javascript:void(0)" title="修改站点信息">',
                //'<i class="glyphicon glyphicon-pencil"></i>',
                //'</a>  ',
                '<a class="remove" href="javascript:void(0)" title="删除站点">',
                '<i class="glyphicon glyphicon-remove"></i>',
                '</a>'
            ].join('');
        }

        // 操作事件响应
        window.operateEvents = {
            //'click .like': function(e, value, row, index) {
            //    alert('You click like action, row: ' + JSON.stringify(row));
            //},
            'click .edit': function (e, value, row, index) {
                //alert('You click edit action, row: ' + JSON.stringify(row));

                //$("#txtId").val(row.Id);
                //$("#txtTitle").val(row.Title);
                //$("#txtOldName").val(row.Title);
                //$("#txtExtension").val(row.Extension);
                //$("#txtFullName").val(row.FullName);
                //$("#txtDirectoryName").val(row.DirectoryName);

                //$('#myModal').modal('toggle'); // 弹出名称修改

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
        /// 删除站点
        /// </summary>

        function DelWebById(id) {
            if (confirm("您确定要删除该站点吗？")) {
                var url = "/Handler/WebHandler.ashx?OP=DELETE&ID=" + id;
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
        /// 批量删除站点
        /// </summary>

        function DelWebByIds(ids) {
            if (confirm("您确定要批量删除这些站点吗？")) {
                var url = "/Handler/WebHandler.ashx?OP=BATCHDELETE&IDs=" + ids;
                $.get(url + "&rnd=" + (Math.random() * 10), function (data) {
                    if (data && data.success) {
                        modals.correct(data.Message);
                    } else {
                        modals.error(data.Message);
                    }
                });
            }
        }
    </script>

</asp:Content>

