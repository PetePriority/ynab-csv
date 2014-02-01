# see http://stackoverflow.com/questions/2897619/using-html5-javascript-to-generate-and-save-a-file
# see http://stackoverflow.com/questions/18662404/download-lengthy-data-as-a-csv-file

angular.element(document).ready ->
  angular.module('app', [])

  angular.module("app").directive "fileread", [->
    scope:
      fileread: "="

    link: (scope, element, attributes) ->
      element.bind "change", (changeEvent) ->
        reader = new FileReader()
        reader.onload = (loadEvent) ->
          scope.$apply ->
            scope.fileread = loadEvent.target.result


        reader.readAsText changeEvent.target.files[0]

  ]

  angular.module("app").directive "dropzone", [->
    transclude: true
    replace: true
    template: '<div class="dropzone"><div ng-transclude></div></div>'
    scope:
      dropzone: "="

    link: (scope, element, attributes) ->
      element.bind 'dragenter', (event) ->
        element.addClass('dragging')
        event.preventDefault();
      element.bind 'dragover', (event) ->
        element.addClass('dragging')
        event.preventDefault();
      element.bind 'dragleave', (event) ->
        element.removeClass('dragging')
        event.preventDefault();

      element.bind 'drop', (event) ->
        element.removeClass('dragging')
        event.preventDefault()
        event.stopPropagation()

        reader = new FileReader()
        reader.onload = (loadEvent) ->
          scope.$apply ->
            scope.dropzone = loadEvent.target.result

        reader.readAsText event.originalEvent.dataTransfer.files[0]

  ]


  # Application code
  angular.module('app').controller 'ParseController', ($scope) ->
    $scope.angular_loaded = true
    $scope.ynab_cols = ['Date','Payee','Category','Memo','Outflow','Inflow']
    $scope.data = {}
    $scope.ynab_map =
      Date:     'Date'
      Payee:    'Payee'
      Category: 'Category'
      Memo:     'Memo'
      Outflow:  'Amount'
      Inflow:   'Amount'
    $scope.data_object = new DataObject()

    $scope.$watch 'data.source', (newValue, oldValue) ->
      $scope.data_object.parse_csv(newValue) if newValue && newValue.length > 0

    $scope.export = (limit) -> $scope.data_object.converted_json(limit, $scope.ynab_map)
    $scope.csvString = -> $scope.data_object.converted_csv(null, $scope.ynab_map)
    $scope.downloadFile = -> window.open('data:text/csv;base64,' + btoa($scope.csvString()))




  angular.bootstrap document, ['app']