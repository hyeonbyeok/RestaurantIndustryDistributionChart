let chart = Highcharts.chart('container', {
    chart: {
        type: 'column'
    },
    title: {
        align: 'left',
        text: ''
    },
    subtitle: {
        align: 'left',
        text: ''
    },
    accessibility: {
        announceNewData: {
            enabled: true
        }
    }, 
    credits: {
	    enabled: false
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
