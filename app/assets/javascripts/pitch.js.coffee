@PitchCtrl = ($scope) ->
  $scope.proposal = {
    number: '1'
    customer_name: 'Dr. Kelly Byron'
    subtotal: ->
      sum = 0.0
      angular.forEach this.rows, (row) ->
        sum += row.extended_price()
      sum
    tax: ->
      this.subtotal() * 0.07 # RI Tax
    total: ->
      this.tax() + this.subtotal()
    rows: [
      {
        quantity: 1
        description: "Widget Wow!"
        sku: "WDGT1000"
        price: 405.00
        position: 1
        extended_price: ->
          this.price * this.quantity
      }
      {
        quantity: 5
        description: "Fangango"
        sku: "FANDANG1"
        price: 5.00
        position: 0
        extended_price: ->
          this.price * this.quantity
      }
    ]
  }

  $scope.orderProp = 'position'
