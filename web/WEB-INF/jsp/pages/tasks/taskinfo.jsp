<%-- 
    Document   : taskinfo
    Created on : 05.07.2016, 12:01:45
    Author     : Alexander Savelev
--%>

<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib uri="http://www.springframework.org/tags/form" prefix="form"%>
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
                <%@include file="../../modules/header.jspf" %>

                <br>

                <div class="row">

                    <%@include file="../../modules/sideMenu/sideMenu_tasks.jspf" %>

                    <br><br>

                    <div class="col-md-10">
                        <div class="panel panel-primary panel-primary-dark">
                            <div class="panel-heading panel-heading-dark" align="center">Задача - <c:out value="${task.title}" /> </div>
                            <div class="panel-body">
                                <table class="table table-hover table-condensed">

                                    <tbody>
                                        <tr>
                                            <th>Описание</th>
                                            <td colspan="4">
                                                <div class="panel panel-info panel-primary-dark">
                                                    <div class="panel-heading panel-heading-dark" align="center">
                                                        <c:out value="${task.title}" />
                                                    </div>
                                                    <div class="panel-body">
                                                        <div style="white-space: pre"><c:out value="${task.text}" /></div>
                                                    </div>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Инициатор</th>
                                            <td>
                                                <a href="<c:url value="/employee?id=${task.creator.id}" />" >
                                                    <c:out value="${task.creator.fullName}" />
                                                </a>
                                            </td>
                                            <th>Назначена</th>
                                            <td>
                                                <c:if test="${task.performers.isEmpty()}">Никому <c:if test="${!task.isClosed()}"><a href="#">(Взять себе)</a></c:if></c:if>
                                                <c:forEach items="${task.performers}" var="performer">
                                                    <a href="<c:url value="/employee?id=${performer.id}" />" >
                                                        <c:out value="${performer.fullName}"/><br>
                                                    </a>
                                                </c:forEach>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>Создана</th>
                                                <fmt:formatDate value="${task.creationTime.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="createfmt" />
                                            <td><c:out value="${createfmt}" /></td>
                                            <th>Срок выполнения</th>
                                                <fmt:formatDate value="${task.deadline.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="deadlinefmt" />
                                            <td><c:out value="${deadlinefmt}" /></td>
                                        </tr>
                                        <tr>
                                            <th>Статус</th>
                                            <td><c:out value="${task.statusString}" /></td>
                                            <c:choose>
                                                <c:when test="${task.closed}">
                                                    <th>Время закрытия</th>
                                                        <fmt:formatDate value="${task.closeTime.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="closefmt" />
                                                    <td><c:out value="${closefmt}" /></td>
                                                </c:when>
                                                <c:otherwise>
                                                    <th>Осталось времени</th>
                                                    <td ${task.overdued ? "class='td-redfont'" : ""}>
                                                        <c:out value="${task.deadlineString}" />
                                                    </td>
                                                </c:otherwise>
                                            </c:choose>
                                        </tr>
                                        <tr>
                                            <th>Важность</th>
                                            <td colspan="4"><c:out value="${task.urgencyString}" /></td>
                                        </tr>
                                        <tr>
                                            <th>Документы задачи</th>
                                            <td colspan="4">
                                                <c:if test="${task.files.isEmpty()}">Прикрепленных документов нет<br></c:if>
                                                <c:forEach items="${task.files}" var="file">
                                                    <fmt:formatDate value="${file.creationTime.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="filetimefmt" />
                                                    <a href="<c:url value="/tasks/getfile/${file.viewName}?taskid=${task.id}&fileid=${file.id}" />" data-toggle="tooltip" data-placement="right" title="Автор: ${file.creator.fullName}&#10;Создан: ${filetimefmt}&#10;Размер: ${file.sizeStr}">
                                                        <img src="<c:url value="/res/images/datafile_types/${file.iconPath}" />" > <c:out value="${file.viewName}" />
                                                    </a>
                                                    <br>
                                                </c:forEach>
                                                    <br>
                                                <c:if test="${!task.isClosed()}">
                                                    <c:url var="file_upload_url"  value="/tasks/addfile?id=${task.id}&${_csrf.parameterName}=${_csrf.token}" />
                                                    <form:form method="post" commandName="taskFileUpload" enctype="multipart/form-data" action="${file_upload_url}">
                                                        Загрузить новый документ: <input type="file" name="file" /> 
                                                        <input type="submit" value="Загрузить" />
                                                    </form:form>
                                                </c:if>
                                            </td>
                                        </tr>

                                        <tr><td> </td></tr>

                                        <tr>
                                            <th>Прогресс</th>
                                            <td colspan="4">
                                                <c:forEach items="${task.comments}" var="comment" >
                                                    <div class="panel panel-info panel-primary-dark">
                                                        <div class="panel-heading panel-heading-dark" align="center">
                                                            <c:choose>
                                                                <c:when test="${comment.creator != null}">
                                                                    <a href="<c:url value="/employee?id=${comment.creator.id}" />">
                                                                        <c:out value="${comment.creator.fullName}" />
                                                                    </a> написал(а)
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Системное сообщение
                                                                </c:otherwise>
                                                            </c:choose>

                                                        </div>
                                                        <div class="panel-body">
                                                            <h4><c:out value="${comment.title}" /></h4>
                                                            <hr>
                                                            <div style="white-space: pre"><c:out value="${comment.text}" /></div>
                                                            <br><br>
                                                            <fmt:formatDate value="${comment.creationTime.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="commenttimefmt" />
                                                            <div align="right"><small><c:out value="${commenttimefmt}" /></small></div>
                                                        </div>
                                                    </div>
                                                </c:forEach>

                                                <c:if test="${!task.isClosed()}">
                                                    <div class="panel panel-info panel-primary-dark">
                                                        <div class="panel-heading panel-heading-dark" align="center">
                                                            Новый комментарий
                                                        </div>
                                                        <div class="panel-body">
                                                            <c:url var="comment_post_url"  value="/tasks/addcomment?taskid=${task.id}" />
                                                            <form:form method="post" commandName="newcomment" action="${comment_post_url}">
                                                                <table class="table table-condensed table-hover">
                                                                    <tbody>
                                                                        <tr>
                                                                            <td>Заголовок</td>
                                                                            <td><form:input path="title" class="form-control" /></td>
                                                                            <td><form:errors path="title" cssStyle="color: #ff0000;" /></td>
                                                                        </tr>
                                                                        <tr>
                                                                            <td>Описание</td>
                                                                            <td><form:textarea path="text" class="form-control" rows="5" /></td>
                                                                            <td><form:errors path="text" cssStyle="color: #ff0000;" /></td>
                                                                        </tr>
                                                                    </tbody>
                                                                </table>

                                                                <fmt:formatDate value="${newcomment.creationTime.toDate()}" type="both" pattern="dd.MM.yyyy HH:mm" var="commenttimefmt" />
                                                                <form:hidden path="creator.id" />
                                                                <form:hidden path="creationTime" value="${commenttimefmt}" />
                                                                <form:errors path="creator" cssStyle="color: #ff0000;" />
                                                                <form:errors path="creationTime" cssStyle="color: #ff0000;" />
                                                                <input id="save" type="submit" name="save" value="Сохранить" class="btn btn-primary">
                                                            </form:form>

                                                        </div>
                                                    </div>
                                                </c:if>
                                            </td>
                                        </tr>

                                    </tbody>
                                </table>

                                <c:choose>
                                    <c:when test="${task.statusString == 'Новая'}" >
                                        <button class="btn btn-primary takeTask" ><span class="glyphicon glyphicon-expand"></span> Взять себе</button>
                                        <c:if test="${task.creator.equals(currentUser)}">
                                            <button class="btn btn-primary closeTask" ><span class="glyphicon glyphicon-expand"></span> Закрыть</button>
                                        </c:if>
                                    </c:when>

                                    <c:when test="${task.statusString == 'Назначена'}" >
                                        <c:if test="${task.creator.equals(currentUser)}">
                                            <button class="btn btn-primary closeTask" ><span class="glyphicon glyphicon-expand"></span> Закрыть</button>
                                        </c:if>
                                    </c:when>

                                    <c:when test="${task.statusString == 'В работе'}" >
                                        <c:if test="${task.creator.equals(currentUser)}">
                                            <button class="btn btn-primary closeTask" ><span class="glyphicon glyphicon-expand"></span> Закрыть</button>
                                        </c:if>
                                    </c:when>
                                    <c:when test="${task.statusString == 'Приостановлена'}" >
                                        <c:if test="${task.creator.equals(currentUser)}">
                                            <button class="btn btn-primary closeTask" ><span class="glyphicon glyphicon-expand"></span> Закрыть</button>
                                        </c:if>
                                    </c:when>
                                </c:choose>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <%@include file="../../modules/footer.jspf" %>
        </div>
        
        <div id="msgCloseConfirm" title="Подтвердите действие">
                <p>
                    Закрыть данную задачу? 
                    <br>
                    Подтвердите что задача выполнена и дальнейших действий не требуется.
                </p>
        </div>

        <script type="text/javascript">
            $(document).ready(function () {
                $('[data-toggle="tooltip"]').tooltip();
                
                $(".closeTask").click(function () {
                    $("#msgCloseConfirm").dialog("open");
                });
                
                $(".takeTask").click(function () {
                    $.post("<c:url value="/tasks/taketask" />", {"id": ${task.id}, "${_csrf.parameterName}": "${_csrf.token}"});
                                setTimeout(function () {
                                    location.reload()
                                }, 300);
                });

                $("#msgCloseConfirm").dialog({
                    autoOpen: false,
                    modal: true,
                    dialogClass: "no-close",
                    width: 400,
                    buttons: [{
                            text: "Закрыть",
                            class: "btn btn-danger",
                            click: function () {
                                //$(this).dialog("close");
                                $.post("<c:url value="/tasks/closetask" />", {"id": ${task.id}, "${_csrf.parameterName}": "${_csrf.token}"});
                                setTimeout(function () {
                                    location.reload()
                                }, 300);

                            }
                        }, {
                            text: "Отмена",
                            class: "btn btn-default",
                            click: function () {
                                $(this).dialog("close");
                            }
                        }],
                    show: {
                        effect: "clip",
                        duration: 200
                    },
                    hide: {
                        effect: "clip",
                        duration: 200
                    }

                });
            });
        </script>
        
    </body>
</html>