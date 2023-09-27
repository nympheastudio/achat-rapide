<!-- product-selection.tpl -->
{extends file='./base.tpl'}

{block name='step_content'}
    <!-- Content specific to the product selection step -->
    <h1>Selection</h1>

    <!-- Display the list of products -->
    <div class="product-selection">
        {foreach from=$product_list item=product}
        <div class="product-selection-item">
            <img src="https://via.placeholder.com/150" alt="{$product.name}">
            <p>{$product.name}</p>
         <!-- <p><a href="index.php?step=choose-papillons&product_id={$product.id_product}">Commander</a></p>-->  
            <p><button class="btn btn-primary" onclick="openChoosePapillonsModal({$product.id_product});">Commander</button></p>
       
        </div>
        {/foreach}
    </div>
    <div 
    data-bs-keyboard="false" data-bs-backdrop="static"
    class="modal fade" id="choosePapillonsModal" tabindex="-1" role="dialog" aria-labelledby="exampleModalCenterTitle" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered" role="document">


            <div class="modal-content">
                <button id="closeBtnChoosePapillonsModal" type="button" class="btn btn-primary" >Retour</button>
                <div class="modal-body"></div>
            </div>
        </div>
    </div>


<!-- JavaScript to open the modal -->
<script>
    //document on click closeBtnChoosePapillonsModal
    $(document).on('click', '#closeBtnChoosePapillonsModal', function() {
        $('#choosePapillonsModal').modal('hide');
        
    });


    function openChoosePapillonsModal(product_id) {
        // Set the 'product_id' in the modal (if needed)
        // For now, let's just display a message
       // document.querySelector('#choosePapillonsModal .modal-body').innerHTML = '<p>Product ID: ' + product_id + '</p>';

        //feed modal #choosePapillonsModal with ajax content from index.php?step=choose-papillons&product_id= + product_id
        $.ajax({
            url: 'index.php?step=choose-papillons&product_id=' + product_id,
            success: function(data) {
                $('#choosePapillonsModal .modal-body').html(data);
            }
        });


        // Open the modal
        $('#choosePapillonsModal').modal('show');
    }
</script>
{/block}




