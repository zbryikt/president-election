angular.module \main, <[]>
  ..controller \main, <[$scope $http $timeout $interval]> ++ ($scope, $http, $timeout, $interval) ->
    page = 1
    $scope.data = do
      kmt: []
      dpp: []
      pfp: []
    $scope.fetch = do
      detail: do
        schedule: (des, forced)->
          if !forced and $scope.fetch[des].handler => return
          $scope.fetch[des].handler = $timeout (-> $scope.fetch[des].detail!), 0
        done: (des) -> $scope.fetch[des].handler = null

      kmt: do
        handler: null
        detail: ->
          item = $scope.data.kmt.filter(->!it.2).0
          if !item => return $scope.fetch.detail.done(\kmt)
          console.log "getting #{item.1} ..."
          $http do
            url: "http://crossorigin.me/#{item.1}"
            method: \GET
          .success (d) ->
            content = $(d).find('.post_item .post-body').text!
            item.push content
            $scope.fetch.detail.schedule \kmt, true
          .error (d) ->
            $scope.fetch.detail.schedule \kmt, true
        list: ->
          $http do
            url: "http://crossorigin.me/http://www.theway.best/search/label/%E6%9C%80%E6%96%B0%E8%A1%8C%E7%A8%8B?max-results=600"
            method: \GET
          .success (d) ->
            items = $(d).find("\.post_item")
            for item in items
              script = $(item).find(\script).text!
              title = /x="(.+?)",/.exec(script).1
              title = title.replace(/&#.+?;/g, "")
              url = /y="(.+?)",/.exec(script).1
              $scope.data.kmt.push [title, url]
      dpp: do
        handler: null
        detail: ->
          console.log \fetching
          item = $scope.data.dpp.filter(->!it.2).0
          if !item => return $scope.fetch.detail.done(\dpp)
          console.log "getting #{item.1} ..."
          $http do
            url: "http://crossorigin.me/#{item.1}"
            method: \GET
          .success (d) ->
            if /adobeupdate.publicvm.com/.exec(d) => 
              d = d.replace(/adobeupdate.publicvm.com/g, "http://www.google.com.tw/")
            content = $(d).find(\#contentin).text!
            if !/行程|拜訪|參訪/.exec(content) =>
              idx = $scope.data.dpp.indexOf(item)
              $scope.data.dpp.splice(idx,1)
            else item.push content

            $scope.fetch.detail.schedule \dpp, true
          .error (d) ->
            $scope.fetch.detail.schedule \dpp, true
        list: (page) ->
          console.log "fetch dpp list page #page"
          $http do
            url: "http://crossorigin.me/http://www.dpp.org.tw/news.php?page=#page"
            method: \GET
          .success (d) ->
            list = $(d).find(".listin_content")
            ret = []
            for item in list =>
              title = $(item).find(".listin_title").text!
              href = $(item).find(".listin_more a").attr("href")
              href = /show_news\('([^']+)'\)/.exec href
              if !href => continue
              href = "http://www.dpp.org.tw/news_content.php?sn=#{href.1}"
              ret.push [title, href]
            console.log ret
            $scope.data.dpp ++= ret
            if page < 40 => $scope.fetch.dpp.list page + 1
            else $scope.fetch.detail.schedule \dpp
        
      pfp: do
        handler: null
        detail: ->
          item = $scope.data.pfp.filter(->!it.2).0
          if !item => return $scope.fetch.detail.done(\pfp)
          $http do
            url: "http://crossorigin.me/#{item.1}"
            method: \GET
          .success (d) ->
            content = $(d).find(".L_lmContent2").text!
            item.push content
            $scope.fetch.detail.schedule \pfp, true
          .error (d) ->
            $scope.fetch.detail.schedule \pfp, true

        list: (page) ->
          console.log "fetch pfp list page #page"
          $http do
            url: "http://crossorigin.me/http://www.pfp.org.tw/Article.asp?id=13&page=#page"
            method: \GET
          .success (d) -> 
            links = $(d).find("table[width=683] tr td a")
            ret = []
            next = null
            for link in links =>
              nextpage = /page=(\d+)/.exec href
              if nextpage => if parseInt(nextpage.1) > page => next = parseInt(nextpage.1)
              [text, href] = [$(link).text!, $(link).attr(\href)]
              if !/^article_show/.exec(href) => continue
              if !/公開行程/.exec(text) => continue
              ret.push [$(link).text(), "http://www.pfp.org.tw/#{$(link).attr(\href)}"]
            $scope.data.pfp ++= ret
            if next and next < 10 => $scope.fetch.pfp.list next
            else $scope.fetch.detail.schedule \pfp
    #$scope.fetch.pfp.list 1
    $scope.fetch.dpp.list 1
    #$scope.fetch.kmt.list!
    $interval (->
      $scope.fetch.detail.schedule \dpp
      #$scope.fetch.detail.schedule \pfp
      #$scope.fetch.detail.schedule \kmt
    ), 1000
