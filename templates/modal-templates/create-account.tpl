

<div id="account">
    <h3>Commande "{$product_name}" </h3>
    <p>Merci de renseigner vos coordonnées pour la livraison</p>
    
    <!--<p>Product ID: {$smarty.get.product_id}</p>
        <p>Papillon ID: {$smarty.get.papillon_id}</p>
        <p>Maquette ID: {$smarty.get.maquette_id}</p>
        <p>Quantity: {$smarty.get.quantity}</p>-->
        
        
        <input type="text" name="nom" id="nom" placeholder="Nom">
        <input type="text" name="prenom" id="prenom" placeholder="Prénom">
        <input type="text" name="email" id="email" placeholder="Email">
        <input type="text" name="adresse" id="adresse" placeholder="Adresse">
        <input type="text" name="code_postal" id="code_postal" placeholder="Code postal">
        <input type="text" name="ville" id="ville" placeholder="Ville">
        <input type="text" name="telephone" id="telephone" placeholder="Télephone">
        
        <button class="btn btn-primary" id="paymentBtn" disabled>Valider</button>
    </div>
    <div data-bs-keyboard="false" data-bs-backdrop="static" class="modal fade" id="createPaymentModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <!-- Modal content goes here -->
        <div class="modal-dialog modal-dialog-centered" role="document">
            <div class="modal-content">
                <div class="modal-body">
                    
                    <!-- Content will be displayed here -->
                    
                </div>
                <button id="closeBtncreatePaymentModal" type="button" class="btn btn-primary" >Annuler ma commande</button>
            </div>
        </div>
        
        <script>
            $(document).ready(function(){
            $(document).on('click', '#closeBtncreatePaymentModal', function() {

                //hide all via body
                $('body').hide();
                
                //reload page
                location.reload();


                $('#createPaymentModal').modal('hide');
                //destroy in pure js
                let el = document.getElementById('createPaymentModal');
                el.parentNode.removeChild(el);
                //$('#createPaymentModal').modal('dispose');
                openCreateAccountModal({$smarty.get.product_id},{$smarty.get.papillon_id},{$smarty.get.maquette_id},{$smarty.get.quantity});
                
            });
            
 
                
                
                function checkFields() {
                    const email = $('#email').val();
                    const nom = $('#nom').val();
                    const prenom = $('#prenom').val();
                    const adresse = $('#adresse').val();
                    const code_postal = $('#code_postal').val();
                    const ville = $('#ville').val();
                    const telephone = $('#telephone').val();
                    
                    // Check if all fields have values
                    const allFieldsFilled = email && nom && prenom && adresse && code_postal && ville && telephone;
                    
                    // Enable or disable the button based on the result
                    $('#paymentBtn').prop('disabled', !allFieldsFilled);
                }
                
                // Call the function initially to set the button state
                checkFields();
                
                $(document).on('input', '#email, #nom, #prenom, #adresse, #code_postal, #ville, #telephone', checkFields);
                
                $(document).on('click', '#closeBtncreatePaymentModal', function() {
                    
                    $('#createPaymentModal').modal('hide');
                    openCreateAccountModal({$smarty.get.product_id},{$smarty.get.papillon_id},{$smarty.get.maquette_id},{$smarty.get.quantity});
                    
                });
                
                
                
                // $('#paymentBtn').click(function() {
                    $(document).on('click', '#paymentBtn', function() {
                        
                        let email = $('#email').val();
                        let nom = $('#nom').val();
                        let prenom = $('#prenom').val();
                        let adresse = $('#adresse').val();
                        let code_postal = $('#code_postal').val();
                        let ville = $('#ville').val();
                        let telephone = $('#telephone').val();
                        
                        //open create account modal
                        
                        openCreatePaymentModal({$smarty.get.product_id},{$smarty.get.papillon_id},{$smarty.get.maquette_id},{$smarty.get.quantity},email,nom,prenom,adresse,code_postal,ville,telephone);
                        
                    });
                    
              
                function openCreatePaymentModal( product_id, papillon_id, maquette_id,quantity,email,nom,prenom,adresse,code_postal,ville,telephone) {
                    
//destroy ##createPaymentModal if exists
$('#createPaymentModal').modal('dispose');

                    $.ajax({
                        
                        url: 'index.php?step=payment&product_id=' + product_id + '&papillon_id=' + papillon_id + '&maquette_id=' + maquette_id + '&quantity=' + quantity + '&email=' + email + '&nom=' + nom + '&prenom=' + prenom + '&adresse=' + adresse + '&code_postal=' + code_postal + '&ville=' + ville + '&telephone=' + telephone, // Update the path to your 'choose-maquette.tpl' file
                        success: function(data) {
                            
                            $('#createPaymentModal .modal-body').html(data);
                            
                        }
                    });
                    $('#account').hide();
                    $('#createPaymentModal').modal('show');
                }
            });
                
            </script>
