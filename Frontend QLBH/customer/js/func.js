const jsoncustomer = JSON.parse(sessionStorage.getItem("jsoncustomer"))

if(jsoncustomer === null){
    console.log("logout")
    location.href = "/customer/login/index.html"
}

// hàm đăng xuất
function logout_forcustomer(){
    sessionStorage.clear()
    location.reload()
  }

function returnDriver(data){
    const customerInfo = Object.values(data)
    const header = document.getElementsByClassName("header-row")
    for(let i = 0; i < customerInfo.length; i++){
        const label = document.createElement("label")
        label.appendChild(document.createTextNode(customerInfo[i]))
        header[i].appendChild(label)
    }
}

//Display info of Customer
returnDriver(jsoncustomer)
