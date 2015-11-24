<%--
  ~ APDPlat - Application Product Development Platform
  ~ Copyright (c) 2013, 杨尚川, yang-shangchuan@qq.com
  ~
  ~  This program is free software: you can redistribute it and/or modify
  ~  it under the terms of the GNU General Public License as published by
  ~  the Free Software Foundation, either version 3 of the License, or
  ~  (at your option) any later version.
  ~
  ~  This program is distributed in the hope that it will be useful,
  ~  but WITHOUT ANY WARRANTY; without even the implied warranty of
  ~  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  ~  GNU General Public License for more details.
  ~
  ~  You should have received a copy of the GNU General Public License
  ~  along with this program.  If not, see <http://www.gnu.org/licenses/>.
  --%>

<%@ page import="org.apdplat.superword.model.Word" %>
<%@ page import="org.apdplat.superword.rule.DependenceWordRule" %>
<%@ page import="org.apdplat.superword.tools.HtmlFormatter" %>
<%@ page import="org.apdplat.superword.tools.WordLinker" %>
<%@ page import="org.apdplat.superword.tools.WordSources" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String dict = request.getParameter("dict");
    if(dict != null){
        WordLinker.dictionary = dict;
    }
    Word word = new Word(request.getParameter("word"), "");
    int column = 10;
    try{
        column = Integer.parseInt(request.getParameter("column"));
    }catch (Exception e){}
    Map<Word, List<Word>> dependence = (Map<Word, List<Word>>)application.getAttribute("dependence");
    if(dependence == null){
        dependence = DependenceWordRule.getDependentWord(WordSources.getAll());
        application.setAttribute("dependence", dependence);
    }
    List<Word> data = dependence.get(word);
    String htmlFragment = "";
    if(data != null){
        Map<Word, List<Word>> temp = new HashMap<Word, List<Word>>();
        temp.put(word, data);
        htmlFragment = HtmlFormatter.toHtmlTableFragmentForIndependentWord(temp, column, Integer.MAX_VALUE).get(0);
    }else{
        htmlFragment = WordLinker.toLink(word.getWord());
    }
%>
<html>
<head>
    <title>词根词缀分析规则</title>
    <script type="text/javascript">
        function submit(){
            var word = document.getElementById("word").value;
            var dict = document.getElementById("dict").value;
            var column = document.getElementById("column").value;

            if(word == ""){
                return;
            }
            location.href = "dependence-word-rule.jsp?word="+word+"&dict="+dict+"&column="+column;
        }
        document.onkeypress=function(e){
            var e = window.event || e ;
            if(e.charCode == 13){
                submit();
            }
        }
    </script>
</head>
<body>
    <h2><a href="https://github.com/ysc/superword" target="_blank">superword主页</a></h2>
    <p>
        ***用法说明:
        词根词缀分析规则，分析单词可能拥有的所有前缀、后缀和词根
    </p>
    <p>
        <font color="red">输入单词：</font><input id="word" name="word" value="<%=word==null?"":word%>" size="50" maxlength="50"><br/>
        <font color="red">选择词典：</font>
        <jsp:include page="dictionary-select.jsp"/><br/>
        <font color="red">每行词数：</font><input id="column" name="column" value="<%=column%>" size="50" maxlength="50"><br/>
    </p>
    <p></p>
    <p><a href="#" onclick="submit();">提交</a></p>
    <%=htmlFragment%>
    <p><a target="_blank" href="index.jsp">主页</a></p>
</body>
</html>