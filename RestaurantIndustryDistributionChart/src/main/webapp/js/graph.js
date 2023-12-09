let chart = Highcharts.chart('container', {
    chart: {
        type: 'column'
    },
    title: {
        align: 'center',
        text: '요식업종 별 그래프'
    },
    subtitle: {
        align: 'left',
        text: ''
    },
    xAxis: {
        type: 'category'
    },
    yAxis: {
        title: {
            text: ''
        }

    },
    legend: {
        enabled: false
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            dataLabels: {
                enabled: true
            }
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:14px;">{series.name}</span><br/>',
        pointFormat: '<span style="color:{point.color}">{point.category}</span> : <b>{point.y}</b><br/>'
    },
    series: [
        {
            name: '',
            colorByPoint: true,
            data: [
            ]
        }
    ]
   
});

let regionChart = Highcharts.chart('regieonGraph', {
    chart: {
        type: 'column'
    },
    title: {
        align: 'center',
        text: '지역 별 그래프'
    },
    subtitle: {
        align: 'left',
        text: ''
    },
    xAxis: {
        type: 'category'
    },
    yAxis: {
        title: {
            text: ''
        }

    },
    legend: {
        enabled: false
    },
    plotOptions: {
        series: {
            borderWidth: 0,
            dataLabels: {
                enabled: true
            }
        }
    },
    tooltip: {
        headerFormat: '<span style="font-size:14px;">{series.name}</span><br/>',
        pointFormat: '<span style="color:{point.color}">{point.category}</span> : <b>{point.y}</b><br/>'
    },
    series: [
        {
            name: '',
            colorByPoint: true,
            data: [
            ]
        }
    ]
   
});

