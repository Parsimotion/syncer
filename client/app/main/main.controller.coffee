'use strict'

app.controller 'MainCtrl', ($scope, $http, Stock) ->
  actualizarEstado = (ajustes, estado) ->
    ajustes.forEach (ajuste) ->
      _.find($scope.ajustes.stocks, sku: ajuste.sku).estadoSincronizacion = estado

  $scope.ajustes = Stock.query()

  $scope.sincronizar = ->
    $scope.isSincronizando = true

    $http.post("/api/stocks").success (resultadoSincronizacion) ->
      actualizarEstado resultadoSincronizacion.fulfilled, "ok"
      actualizarEstado resultadoSincronizacion.failed, "error"

      $scope.isSincronizando = false
