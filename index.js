var x$;x$=angular.module("main",[]),x$.controller("main",["$scope","$http","$timeout","$interval"].concat(function(t,e,n,p){var r;return r=1,t.data={dpp:[],pfp:[]},t.fetch={detail:{schedule:function(e,p){return p||!t.fetch[e].handler?t.fetch[e].handler=n(function(){return t.fetch[e].detail()},0):void 0},done:function(e){return t.fetch[e].handler=null}},dpp:{handler:null,detail:function(){var n;return console.log("fetching"),(n=t.data.dpp.filter(function(t){return!t[2]})[0])?(console.log("getting "+n[1]+" ..."),e({url:"http://crossorigin.me/"+n[1],method:"GET"}).success(function(e){var p,r;return p=$(e).find("#contentin").text(),/行程|拜訪|參訪/.exec(p)?n.push(p):(r=t.data.dpp.indexOf(n),t.data.dpp.splice(r,1)),t.fetch.detail.schedule("dpp",!0)}).error(function(){return t.fetch.detail.schedule("dpp",!0)})):t.fetch.detail.done("dpp")},list:function(n){return console.log("fetch dpp list page "+n),e({url:"http://crossorigin.me/http://www.dpp.org.tw/news.php?page="+n,method:"GET"}).success(function(e){var p,r,c,i,l,d,o,f;for(p=$(e).find(".listin_content"),r=[],c=0,i=p.length;i>c;++c)l=p[c],d=$(l).find(".listin_title").text(),o=$(l).find(".listin_more a").attr("href"),o=/show_news\('([^']+)'\)/.exec(o),o&&(o="http://www.dpp.org.tw/news_content.php?sn="+o[1],r.push([d,o]));return console.log(r),(f=t.data).dpp=f.dpp.concat(r),40>n?t.fetch.dpp.list(n+1):t.fetch.detail.schedule("dpp")})}},pfp:{handler:null,detail:function(){var n;return n=t.data.pfp.filter(function(t){return!t[2]})[0],n?e({url:"http://crossorigin.me/"+n[1],method:"GET"}).success(function(e){var p;return p=$(e).find(".L_lmContent2").text(),n.push(p),t.fetch.detail.schedule("pfp",!0)}).error(function(){return t.fetch.detail.schedule("pfp",!0)}):t.fetch.detail.done("pfp")},list:function(n){return console.log("fetch pfp list page "+n),e({url:"http://crossorigin.me/http://www.pfp.org.tw/Article.asp?id=13&page="+n,method:"GET"}).success(function(e){var p,r,c,i,l,d,o,f,a,h;for(p=$(e).find("table[width=683] tr td a"),r=[],c=null,i=0,l=p.length;l>i;++i)d=p[i],o=/page=(\d+)/.exec(h),o&&parseInt(o[1])>n&&(c=parseInt(o[1])),f=[$(d).text(),$(d).attr("href")],a=f[0],h=f[1],/^article_show/.exec(h)&&/公開行程/.exec(a)&&r.push([$(d).text(),"http://www.pfp.org.tw/"+$(d).attr("href")]);return(f=t.data).pfp=f.pfp.concat(r),c&&10>c?t.fetch.pfp.list(c):t.fetch.detail.schedule("pfp")})}}},t.fetch.pfp.list(1),t.fetch.dpp.list(1),p(function(){return t.fetch.detail.schedule("dpp"),t.fetch.detail.schedule("pfp")},1e3)}));