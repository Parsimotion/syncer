'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock, Settings, Auth) ->
  actualizarEstado = (ajustes, estado) ->
    ajustes.forEach (ajuste) ->
      _.find($scope.ajustes.ajustes, sku: ajuste.sku).estadoSincronizacion = estado

  $scope.ajustes = Stock.query()
  $scope.settings = Settings.query()
  Auth.getCurrentUser().$promise.then (user) ->
    $scope.lastSync = user.lastSync

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/adjustments").success (resultadoSincronizacion) ->
      $scope.lastSync = resultadoSincronizacion
      $scope.isSincronizando = false

      actualizarEstado resultadoSincronizacion.linked, "ok"
      actualizarEstado resultadoSincronizacion.unlinked, "error"
