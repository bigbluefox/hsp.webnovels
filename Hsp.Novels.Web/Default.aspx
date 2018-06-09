<%@ Page Title="" Language="C#" MasterPageFile="~/PageMaster/BootStrap.master" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" Runat="Server">
    站点列表
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ScriptContent" Runat="Server">

    <link href="/Scripts/bootstrap/css/bootstrap-table.min.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-validator.css" rel="stylesheet"/>
    <link href="/Scripts/bootstrap/css/bootstrap-datetimepicker.min.css" rel="stylesheet"/>

    <style type="text/css"></style>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContainerContent" Runat="Server">

    <h3 class="page-header">站点管理</h3>
    
    <div class="result-message"></div>

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
            <button id="btnAdd" class="btn btn-primary">
                <i class="glyphicon glyphicon-plus"></i> 添加站点
            </button>
        </div>
    </div>

    <table id="web-table" data-mobile-responsive="true" data-toggle="table"></table>

</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="ModalContent" Runat="Server">
    
    <div class="modal fade" id="editModel" tabindex="-1" role="dialog" aria-labelledby="editModelLabel">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title" id="editModelLabel">站点信息修改</h4>
                </div>
                <div class="modal-body">
                    <form>
                        <div class="form-group">
                            <label for="txtName">站点名称<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtName" placeholder="站点名称..." required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtUrl">站点地址<span class="required">*</span></label>
                            <input type="text" class="form-control" id="txtUrl" placeholder="站点地址..." required="required">
                        </div>
                        <div class="form-group">
                            <label for="txtContentName">内容对象</label>
                            <input type="text" class="form-control" id="txtContentName" placeholder="内容对象...">
                        </div>
                        <div class="form-group">
                            <label for="txtHeaderName">标题对象</label>
                            <input type="text" class="form-control" id="txtHeaderName" placeholder="标题对象...">
                        </div>
                        
                        <%--SELECT     TOP (200) Id, Name, WebUrl, Valid, ContentName, HeaderName, NextName, NextTitle, CreateTime
                        FROM         WebSites  --%>                      

                        <div class="form-group">
                            <label for="txtNextName">地址对象</label>
                            <input type="text" class="form-control" id="txtNextName" placeholder="地址对象...">
                        </div>
                        <div class="form-group">
                            <label for="txtNextTitle">结束标识</label>
                            <input type="text" class="form-control" id="txtNextTitle" placeholder="下一章地址对象结束标识...">
                        </div>
                        <div class="form-group">
                            <label for="txtNextTitle">地址组合</label>
                            <select class="form-control" id="selUrlCombine">
                              <option value="0">无</option>
                              <option value="1">网站 + 章节地址</option>
                              <option value="2">小说 + 章节地址</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>是否有效</label>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" id="chbValid">
                                    站点是否有效
                                </label>
                            </div>
                        </div>
                        <div class="form-group" style="display: none;">
                            <label>地址组合</label>
                            <div class="checkbox">
                                <label>
                                    <input type="checkbox" id="chbUrlCombine">
                                    地址是否需要组合，即章节地址需要跟小说地址组合后才能访问章节？
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
                    <input type="hidden" id="txtId">
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

<script src="/Scripts/Hsp.Formater.js"></script>

<script type="text/javascript">

    var $table = $('#web-table'),
        $remove = $('#remove'),
        selections = [],
        key = 'Id';

    var pageNumber = 1, width = 0;
    var pageListUrl = "/Handler/WebHandler.ashx?OP=LIST";

    $(function() {

        width = Hsp.Common.AvailWidth();

        $table = $('#web-table'),
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
            $("#editModelLabel").html("站点信息添加");
            $('#editModel').modal('toggle'); // 弹出添加窗体            
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

//SELECT     TOP (200) Id, Name, WebUrl, Valid
//, ContentName, HeaderName, NextName, NextTitle, CreateTime，ChildCount
//FROM         WebSites

                    {
                        title: '编号',
                        field: 'Id',
                        align: 'center',
                        visible: false,
                        width: 60
                    }, {
                        field: 'Name',
                        title: '站点名称',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'WebUrl',
                        title: '地址',
                        halign: 'center',
                        align: 'left',
                        formatter: titleFormatter
                    }, {
                        field: 'ContentName',
                        title: '内容类名',
                        width: 105,
                        halign: 'center',
                        align: 'left',
                    }, {
                        field: 'HeaderName',
                        title: '标题类名',
                        width: 105,
                        halign: 'center',
                        align: 'left',
                    }, {
                        field: 'NextName',
                        title: '下一章类名',
                        width: 105,
                        halign: 'center',
                        align: 'left',
                    }, {
                        field: 'NextTitle',
                        title: '结束标识',
                        width: 105,
                        align: 'center'
                    }, {
                        field: 'ChildCount',
                        title: '小说数',
                        width: 60,
                        halign: 'center',
                        align: 'right',
                        visible: width > Hsp.Mobile.DefaultWidth,
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

            DelWebByIds(ids); // 批量删除
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
            '<a class="detail" href="javascript:void(0)" title="小说管理">',
            '<i class="glyphicon glyphicon-th-list"></i>',
            '</a>  ',
            '<a class="edit" href="javascript:void(0)" title="修改站点">',
            '<i class="glyphicon glyphicon-edit"></i>',
            '</a>  ',
            '<a class="remove" href="javascript:void(0)" title="删除站点">',
            '<i class="glyphicon glyphicon-remove"></i>',
            '</a>'
        ].join('');
    }

    // 操作事件响应
    window.operateEvents = {
        'click .detail': function (e, value, row, index) {
            //alert('You click edit action, row: ' + JSON.stringify(row));

            Page("Novel.aspx?webId=" + row.Id + "&webName=" + encodeURIComponent(row.Name));

        },
        'click .edit': function(e, value, row, index) {
            //alert('You click edit action, row: ' + JSON.stringify(row));

            //SELECT     TOP (200) Id, Name, WebUrl, Valid, ContentName, HeaderName, NextName, NextTitle, CreateTime
            //FROM         WebSites chbUrlCombine

            $("#txtId").val(row.Id);
            $("#txtName").val(row.Name);
            $("#txtUrl").val(row.WebUrl);
            $("#txtContentName").val(row.ContentName);
            $("#txtHeaderName").val(row.HeaderName);
            $("#txtNextName").val(row.NextName);
            $("#txtNextTitle").val(row.NextTitle);

            if (row.Valid == 1) {
                document.getElementById("chbValid").checked = true; // 设置是否有效复选框为选中状态
            }
            //if (row.UrlCombine == 1) {
            //    document.getElementById("chbUrlCombine").checked = true; // 设置地址组合复选框为选中状态
            //}

            $("#selUrlCombine").val(row.UrlCombine);

            $("#editModelLabel").html("站点信息修改");
            $('#editModel').modal('toggle'); // 弹出名称修改

        },
        'click .remove': function(e, value, row, index) {
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
    /// 批量删除站点
    /// </summary>

    function DelWebByIds(ids) {
        if (confirm("您确定要批量删除这些站点吗？")) {
            var url = "/Handler/WebHandler.ashx?OP=BATCHDELETE&IDs=" + ids;
            $.get(url + "&rnd=" + (Math.random() * 10), function(data) {
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

            $("#txtId").val("");
            $("#txtName").val("");
            $("#txtUrl").val("");
            $("#txtContentName").val("");
            $("#txtHeaderName").val("");
            $("#txtNextName").val("");
            $("#txtNextTitle").val("");

            $("#chbValid").removeAttr("checked");
            //$("#chbUrlCombine").removeAttr("checked");
            $("#selUrlCombine").val("0");
        });

        //SELECT TOP (200) Id, Name, WebUrl, Valid, ContentName, HeaderName, NextName, NextTitle, CreateTime
        //FROM WebSites chbValid

        // 数据保存按钮点击事件 
        $("#btnSave").unbind("click").bind("click", function () {

            var params = {
                id: $("#txtId").val(),
                name: $("#txtName").val(),
                webUrl: $('#txtUrl').val(),
                contentName: $("#txtContentName").val(),
                headerName: $('#txtHeaderName').val(),
                nextName: $('#txtNextName').val(),
                nextTitle: $('#txtNextTitle').val(),
                valid: document.getElementById("chbValid").checked ? "1" : "0",
                urlCombine: $("#selUrlCombine").val()
            };

            $.ajax({
                type: "POST",
                url: "/Handler/WebHandler.ashx?OP=SAVE&rnd=" + (Math.random() * 10),
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