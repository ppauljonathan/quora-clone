function changeTotalPrice() {
  val1 = Number(document.getElementById('induvidual_price').innerText)
  quantity = Number(document.getElementById('order_credit_pack_quantity').value)
  output = document.getElementById('total_price')
  output.innerText = Math.floor(val1 * quantity * 100) / 100
}
