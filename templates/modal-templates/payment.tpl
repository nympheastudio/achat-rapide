<div id="payment_form">
  
  <!-- 
  
 
    
    <p>p id: {$smarty.get.product_id}</p>
    <p>pap id: {$smarty.get.papillon_id}</p>
    <p>Maquette ID: {$smarty.get.maquette_id}</p>
    <p>Quantity: {$smarty.get.quantity}</p>
    <p>Email: {$smarty.get.email}</p>
    <p>Nom: {$smarty.get.nom}</p>
    <p>Prenom: {$smarty.get.prenom}</p>
    <p>Adresse: {$smarty.get.adresse}</p>
    <p>Code Postal: {$smarty.get.code_postal}</p>
    <p>Ville: {$smarty.get.ville}</p>
    <p>Telephone: {$smarty.get.telephone}</p>
  -->
  <style>

    #payment-form {
      width: 100%;
      max-width: 500px;
      margin: 0 auto;

      /*min height 300px to display error messages*/
      min-height: 180px;
    }

    #payment-button {
      display: none;
    }

    #btn_pay{
      margin-top:15px;



    }

    .loader {
  background: url('https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.3/images/loading.gif') no-repeat center center;
  height: 100px;
  width: 100px;
  position: absolute;
  top: 50%;
  left: 50%;
  margin: -50px 0 0 -50px;
}
  </style>
  <form action="charge.php" method="post" id="payment-form">
    <h3> Montant total à payer {$total}€</h3>
    <div class="form-row">
      <label for="card-element">
       
      </label><div id="loader" class="loader"></div>
      <div id="card-element">
        <!-- A Stripe Element will be inserted here. -->
      </div>
      
      <!-- Used to display form errors. -->
      <div id="card-errors" role="alert"></div>
    </div>
    
    <button class="btn btn-primary" id="btn_pay">Payer</button>
    
  </form>
  
</div>

<div data-bs-keyboard="false" data-bs-backdrop="static" class="modal fade" id="successModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
  <!-- Modal content goes here -->
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-body">
        
        <!-- Content will be displayed here -->
        
      </div>
      
    </div>
  </div>
</div>


<script>

  $(document).ready(function() {



   $('#btn_pay').hide();
 // Reference to the loader element
 var loader = $('#loader');

// Hide the loader initially
loader.show();

setTimeout(function() {
  loader.hide();
  $('#btn_pay').show();
}, 3000);


//btn_pay on click hide it to prevent double click
$('#btn_pay').click(function(){
  $(this).hide();
  loader.show();
});

    
    // Create a Stripe Elements instance and mount the card element
    var elements = stripe.elements();
    var cardElement = elements.create('card');
    cardElement.mount('#card-element');
    
    // Handle form submission
    var form = document.getElementById('payment-form');
    form.addEventListener('submit', function(event) {
      event.preventDefault();

     

      stripe.createToken(cardElement).then(function(result) {
        if (result.error) {
          // Display error message to the user
          var errorElement = document.getElementById('card-errors');
          errorElement.textContent = result.error.message;
          loader.hide();
          $('#btn_pay').show();
           
        } else {
          
          // Send the token and additional data to your server for payment processing
          var token =  result.token.id; 
          var product_id = {$smarty.get.product_id};
          var papillon_id = {$smarty.get.papillon_id};
          var maquette_id = {$smarty.get.maquette_id};
          var quantity = {$smarty.get.quantity};
          var email = '{$smarty.get.email}';
          var nom = '{$smarty.get.nom}';
          var prenom = '{$smarty.get.prenom}';
          var adresse = '{$smarty.get.adresse}';
          var code_postal = '{$smarty.get.code_postal}';
          var ville = '{$smarty.get.ville}';
          var telephone = '{$smarty.get.telephone}';
          var total = '{$total}';
          
          
          // Include additional data like product_id, papillon_id, etc., in the POST request to your server
          var formData = new FormData(form);
          formData.append('stripe_token', token);
          formData.append('product_id', product_id);
          formData.append('papillon_id', papillon_id);
          formData.append('maquette_id', maquette_id);
          formData.append('quantity', quantity);
          formData.append('email', email);
          formData.append('nom', nom);
          formData.append('prenom', prenom);
          formData.append('adresse', adresse);
          formData.append('code_postal', code_postal);
          formData.append('ville', ville);
          formData.append('telephone', telephone);
          formData.append('total', total);
          
          
          // Make an AJAX request to your server
          fetch('charge.php', {
            method: 'POST',
            body: formData,
          })
          .then(function(response) {
            // Handle the server response (e.g., success or error message)
            
            
            
            return response.text();
          })
          .then(function(responseText) {
            console.log(responseText); // Log the server response
            
            //if === 'Payment successful'
            if(responseText === 'Payment successful'){
              //show modal success
              openSuccessModal();
              loader.hide();
              //hide paiement form
              $('#payment_form').hide();
              
            }
            
            // You can redirect or display a success message to the user here
          })
          .catch(function(error) {
            console.error(error);
            $('#btn_pay').show();
            loader.hide();
          });
        }
      });
    });
    
    function openSuccessModal() {
      loader.hide();
      document.querySelector('#successModal .modal-body').innerHTML = '<p>Merci pour votre commande<br>Vous allez recevoir un email avec les informations de suivi de commande.<br>Pour la réalisation du fichier graphique de votre carte de voeux,<br>notre équipe va prendre contact avec vous afin de réaliser la maquette</p>';

      $('#successModal').modal('show');
      $('#closeBtncreatePaymentModal').hide();
    }   
    
    
  });
</script>