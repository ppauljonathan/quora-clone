reportAbuse = (reportableType, reportableId) => {
  const csrf = document.querySelector("meta[name='csrf-token']").getAttribute("content");
  if(document.getElementsByClassName('report-abuse-form-wrap').length > 0) { return }
  d = document.createElement('div')
  d.classList.add('report-abuse-form-wrap')
  main = document.getElementsByClassName('main')[0]
  d.innerHTML = `
  <div class="report-abuse-form">
    <button class="function-button" onclick="closeAbuseForm()">X</button>
    <form action="/abuse_reports" method="POST">
      <div class="form-heading">Report Abuse</div>
      <input type="hidden" name="authenticity_token" value=${csrf}>
      <input type="hidden" name="abuse_report[reportable_type]" value=${reportableType}>
      <input type="hidden" name="abuse_report[reportable_id]" value=${reportableId}>
      <input type="hidden" name="abuse_report[content]" id="report-content">
      <trix-editor input="report-content" class="my-trix-mod" placeholder="Please state a reason"></trix-editor>
      <input type="submit" class="function-button">
    </form>
  </div>
  `
  main.appendChild(d)
}

closeAbuseForm = () => {
  d = document.getElementsByClassName('report-abuse-form-wrap')[0]
  d.remove();
}
