window.onload = async() => {
  response = await fetch('/notifications/read_all', { method: 'POST' })
  // data = await response.json()
  console.log(response)
}
