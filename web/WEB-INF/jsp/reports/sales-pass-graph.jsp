<%-- 
    Document   : sales-pass-graph
    Created on : 04.05.2016, 9:52:54
    Author     : Alexander Savelev
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">


<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="<c:url value="/res/css/bootstrap.css" />" >
        <link rel="stylesheet" href="<c:url value="/res/css/bootstrap-theme.css" />" >
        <link rel="stylesheet" href="<c:url value="/res/css/jqgrid/jquery-ui.css" />" >
        <link rel="stylesheet" href="<c:url value="/res/css/jqgrid/jquery-ui.theme.css" />" >
        <link rel="stylesheet" href="<c:url value="/res/css/styles.css" />" >
        <title><c:out value="${title}" /></title>
    </head>

    <body>
        <div class="wrapper">
            <div class="container-fluid content">
                <%@include file="../modules/header.jspf" %>

                <br>

                <div class="row">

                    <%@include file="../modules/sideMenu/sideMenu_reports_sp.jspf" %> 

                    <br><br>

                    <div class="col-md-10">
                        <div class="panel panel-primary panel-primary-dark">
                            <div class="panel-heading panel-heading-dark" align="center">Графики проходимости и выручек по магазину: 
                                <u><c:out value="${shop.name}" /></u> за период 
                                <u>с <c:out value="${dateStartStr}" /> по <c:out value="${dateEndStr}" /></u>
                            </div>
                            <div class="panel-body">

                                <!-- Выбор периода и магазина -->
                                <div class="form-inline" align="right">
                                    <form name="dateChooseForm" action="<c:url value="/reports/graph/sales-pass" />" method="GET">
                                        Магазин: 
                                        <select name="shopid" class="form-control" >
                                            <c:forEach items="${shopList}" var="shp" >
                                                <option ${shp == shop ? "selected" : ""} value="${shp.id}">
                                                    <c:out value="${shp.name}" />
                                                </option>
                                            </c:forEach>
                                        </select>
                                        Показать данные за период с  
                                        <input type="text" name="dateStartStr" id="dateStartField" value="${dateStartStr}" class="form-control datepicker-z">
                                        по
                                        <input type="text" name="dateEndStr" id="dateEndField" value="${dateEndStr}" class="form-control datepicker-z"> 
                                        &nbsp;
                                        <input type="submit" value="Загрузить" class="btn btn-primary">
                                    </form>
                                    <br>
                                </div>

                                <h3 align="center">Проходимость и продажи</h3>
                                <div id="placeholder-sales" class="graph-placeholder">

                                </div>

                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <%@include file="../modules/footer.jspf" %>          
        </div>

        <script type="text/javascript" src="<c:url value="/res/js/jquery.flot.min.js" />"></script>
        <script type="text/javascript" src="<c:url value="/res/js/jquery.flot.categories.min.js" />"></script>
        <script type="text/javascript" src="<c:url value="/res/js/jquery.flot.crosshair.min.js" />"></script>
        <script type="text/javascript" src="<c:url value="/res/js/jquery.flot.tickrotor.js" />"></script>
        <script type="text/javascript" src="<c:url value="/res/js/datepicker-ru.js" />"></script>
        <script type="text/javascript">
            $(function () {

                var sales_data = [
                    {data: ${graphDataDayTotal}, label: "Выручка",
                        lines: {
                            show: true,
                            fill: true
                        }
                    },
                    {data: ${graphDataPassability}, label: "Проходимость", yaxis: 2,
                        bars: {
                            show: true,
                            align: "center"
                        }

                    }
                ];

                var plot_conf = {
                    grid: {
                        hoverable: true
                    },
                    xaxes: [{
                        mode: "categories",
                        rotateTicks: 45
                    }],
                    yaxes: [{ min: 0 }, {
                        alignTicksWithAxis: 1,
                        position: "right"
                    }]
                };

                $.plot("#placeholder-sales", sales_data, plot_conf);

                $("<div id='tooltip'></div>").css({
                    position: "absolute",
                    display: "none",
                    border: "1px solid #fdd",
                    padding: "2px",
                    "background-color": "#fee",
                    opacity: 0.80
                }).appendTo("body");

                $("#placeholder-sales").bind("plothover", function (event, pos, item) {
                    if (item) {
                        var v = item.datapoint[1];
                        $("#tooltip").html(item.series.label + ": " + v)
                                .css({top: item.pageY + 5, left: item.pageX + 5})
                                .fadeIn(200);
                    } else {
                        $("#tooltip").hide();
                    }
                });
                
                
                $("#dateStartField").datepicker();
                $("#dateEndField").datepicker();
            });
        </script>


    </body>
</html>