<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<head>
    <meta charset="UTF-8">
    <script src="/crm/jquery/ECharts/echarts.min.js"></script>
    <script type="text/javascript" src="/crm/jquery/jquery-1.11.1-min.js"></script>
</head>

<body>

<div id="main" style="width: 1000px;height:400px;"></div>
<div id="main1" style="width: 1000px;height:400px;maring-top:30px"></div>

<script type="text/javascript">
    // 基于准备好的dom，初始化echarts实例
    var myChart = echarts.init(document.getElementById('main'));
    var myChart1 = echarts.init(document.getElementById('main1'));
    $.post("/crm/workbench/chart/transactionBarEcharts",function(data){
        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '交易统计图表'
            },
            tooltip: {},
            legend: {
                data:['交易']
            },
            xAxis: {
                data: data.titles
            },
            yAxis: {},
            series: [{
                name: '交易',
                type: 'bar',
                data: data.data
            }]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart.setOption(option);
    },'json');

    $.post("/crm/workbench/chart/transactionPieEcharts",function(data){
        // 指定图表的配置项和数据
        var option = {
            title: {
                text: '交易统计图表',
                subtext: '交易',
                left: 'center'
            },
            tooltip: {
                trigger: 'item'
            },
            legend: {
                orient: 'vertical',
                left: 'left',
            },
            series: [
                {
                    name: '交易信息',
                    type: 'pie',
                    radius: '70%',
                    data: data,
                    emphasis: {
                        itemStyle: {
                            shadowBlur: 10,
                            shadowOffsetX: 0,
                            shadowColor: 'rgba(255, 0, 0, 1)'
                        }
                    }
                }
            ]
        };

        // 使用刚指定的配置项和数据显示图表。
        myChart1.setOption(option);
    },'json');


</script>
</body>