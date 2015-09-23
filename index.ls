angular.module \main, <[]>
  ..controller \main, <[$scope $http]> ++ ($scope, $http) ->
    page = 1
    $scope.data = do
      list: []
    $scope.fetch = do
      detail: ->
        item = $scope.data.list.filter(->!it.2).0
        if !item => return
        $http do
          url: "http://crossorigin.me/#{item.1}"
          method: \GET
        .success (d) ->
          content = $(d).find(".L_lmContent2").text!
          item.push content
          $scope.fetch.detail!
      list: (page) ->
        console.log "fetch list page #page"
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
          $scope.data.list ++= ret
          if next and next < 10 => $scope.fetch.list next
          else $scope.fetch.detail!
    $scope.fetch.list 1
