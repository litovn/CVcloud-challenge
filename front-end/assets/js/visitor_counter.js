const counterElement = document.getElementById('visit-counter');
fetch('https://0v8cek1j53.execute-api.eu-south-1.amazonaws.com/counter/', {
    method: 'POST',
    mode: 'cors'
})
.then(response => response.json())
.then(data => {
    counterElement.textContent = data.body;
})