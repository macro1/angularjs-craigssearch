angular.module("search",["ngSanitize","ngRoute","search.services","search.controllers"]).config(["$routeProvider",function(e){return e.when("/search",{}).otherwise({redirectTo:"/search"})}]);var __indexOf=[].indexOf||function(e){for(var r=0,t=this.length;t>r;r++)if(r in this&&this[r]===e)return r;return-1};angular.module("search.controllers",["search.services"]).controller("SearchController",["$scope","$filter","$location","$http","cities",function(e,r,t,s,n){var i;return e.query=t.search(),e.result=[],e.query.c=e.query.c||"sss",e.hide_city_list=!0,e.errors=[],e.cities=n,e.categories={ccc:"community",eee:"events",ggg:"gigs",hhh:"housing",jjj:"jobs",ppp:"personals",res:"resumes",sss:"for sale",bbb:"services"},e.search=function(r){var s;return r.cities=function(){var r,t,n,i;for(n=e.cities.selected(),i=[],r=0,t=n.length;t>r;r++)s=n[r],i.push(s.slug);return i}().join(","),t.search(r),e.query.q?(e.errors.length=0,e.result.length=0,e.load(),e.hide_city_list=!0):void 0},e.load=function(){var r;return r=function(r){return function(t){var s,n,i,c;if(r.status="processing",t.error)return e.errors.push(r.name),r.status="error";for(c=t.entries,n=0,i=c.length;i>n;n++)s=c[n],s.publishedDate=Date.parse(s.publishedDate);return e.result=e.result.concat(t.entries),r.status="success",e.$apply()}},e.result.length=0,e.cities.promise.then(function(){var t,s,n,i,c;for(i=e.cities.selected(),c=[],s=0,n=i.length;n>s;s++)t=i[s],t.status="pending",c.push(feednami.load("http://"+t.slug+".craigslist.org/search/"+e.query.c+"?query="+e.query.q+"&sort=date&format=rss").then(r(t)));return c})},e.set_all_cities=function(r){var t,s,n,i,c;for(i=e.cities.all,c=[],s=0,n=i.length;n>s;s++)t=i[s],c.push(t.selected=r);return c},e.now=function(){return new Date},i=(e.query.cities||"").split(","),e.cities.promise.then(function(){var r,t,s,c,o;for(c=n.all,t=0,s=c.length;s>t;t++)r=c[t],r.selected=(o=r.slug,__indexOf.call(i,o)>=0);return e.search(e.query)})}]),angular.module("search").filter("delta",function(){return function(e){var r,t,s,n;return n=Math.floor(e/1e3),s=Math.floor(n/60),t=Math.floor(s/60),r=Math.floor(t/24),r>0?r+"d "+(t-24*r)+"h":t>0?t+"h "+(s-60*t)+"m":s>0?s+"m "+(n-60*s)+"s":n+"s"}}),angular.module("search.services",[]).factory("cities",["$http","$filter","$q",function(e,r){var t;return t=[],{all:t,promise:e.get("data/cities.json").success(function(e){return angular.copy(e,t)}),selected:function(){return r("filter")(this.all,{selected:!0})}}}]);