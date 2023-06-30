function renderError() {
  err = document.createElement('div')
  err.class = 'error-block'
  err.innerHTML = 'An Error Occured'
  document.body.childNodes.unshift(err)
}

async function upvote(event, upvotableType, upvotableId) {

  url = '/votes/upvote'
  data = {
    vote: {
      votable_type: upvotableType,
      votable_id: upvotableId
    }
  }

  const response = await fetch(url, {
    method: 'POST',
    mode: 'same-origin',
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  })

  jsonData = await response.json();
  
  if(response.status == 422) { return renderError() }

  svg = event.target
  sibling = svg.parentElement.parentElement.lastElementChild.lastElementChild
  number = svg.parentElement.parentElement.children[1]
  val = Number(number.innerText)
  if(svg.style.fill == 'var(--red)') {
    svg.style.fill = 'var(--bright-black)'
  } else {
    svg.style.fill = 'var(--red)'
    sibling.style.fill = 'var(--bright-black)'
    
  }
 
  number.innerText = jsonData.net_vote_count
}

async function downvote(event, upvotableType, upvotableId) {
  url = '/votes/downvote'
  data = {
    vote: {
      votable_type: upvotableType,
      votable_id: upvotableId
    }
  }

  const response = await fetch(url, {
    method: 'POST',
    mode: 'same-origin',
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  })

  jsonData = await response.json();
  
  if(response.status == 422) { return renderError() }

  svg = event.target
  sibling = svg.parentElement.parentElement.firstElementChild.lastElementChild
  number = svg.parentElement.parentElement.children[1]
  val = Number(number.innerText)
  if(svg.style.fill == 'var(--blue)') {
    svg.style.fill = 'var(--bright-black)'
  } else{
    svg.style.fill = 'var(--blue)'
    sibling.style.fill = 'var(--bright-black)'
  }

  number.innerText = jsonData.net_vote_count
}
