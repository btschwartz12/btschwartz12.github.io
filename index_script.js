#!javascript
function displaySum() {
  let firstNum = Number(document.getElementById('num1').value)
  let secondNum = Number(document.getElementById('num2').value)

  let total = firstNum + secondNum;
  document.getElementById("answer").innerHTML = ` ${firstNum} + ${secondNum}, equals to ${total}` ;
}

document.getElementById('sumButton').addEventListener("click", displaySum);

