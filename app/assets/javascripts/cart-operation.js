$(document).ready(function() {
  handleProcess = {

    init: function(){
      this.bindUIActions();

      if($('#cart').find('.cart-item').length > 0){
        $("#checkout").fadeIn(500);
      }
    },

    bindUIActions: function() {
      this.listProduct();
      this.addToCart();
      this.removeItemFromCart();
      this.checkoutOrder();
      this.handleCalculations();
      this.applyCoupnes();
    },

    listProduct: function() {      
      $(document).on('click', '.product-categories', function(e){
        e.preventDefault();
        categoryId = $(this).data('category-id');

        $.ajax({
          url: "/categories/fetch_products", 
          data: { category_id: categoryId },
          success: function(result){
            $(".product-list").html('');
            $(".product-list").html(result.html);
            ShoppingCart.init();
          }
        });
      });
    },

    addToCart: function(){
      var self = this;

      $(document).on('click', '.add_to_cart', function(e){
        e.preventDefault();
        productId = $(this).data('product-id');

        cartItem = $(this);

        if(productId){
          $.ajax({
            method: 'post',
            url: "/users/add_product_to_cart", 
            data: { product_id: productId },
            success: function(result){
              if(result.error){
                swal({
                  icon: 'danger',
                  title: "Error",
                  text: result.error,
                });
              }else{
                self.applyAddToCartHtml(cartItem, result.cart_id);
              }
            }
          });
        }

      });
    },

    removeItemFromCart: function(){
      $(document).on('click', '.delete-item', function(e){
        e.preventDefault();
        item = $(this);
        cartId = $(this).data('cart-id');

        if(cartId){

          $.ajax({
            method: 'POST',
            url: '/cart_items/' + cartId + '/delete_cart_item' , 
            success: function(result){
              item.parents('.cart-item').remove();
            }
          });
        }

      })
    },

    checkoutOrder: function(){
      $(document).on('click', '#checkout', function(){

        $.ajax({
          method: 'GET',
          url: '/users/cart_items' , 
          success: function(result){
            $('.cart-items-list').html(result.html);
            $('#ex1').modal();
            $('.qty').trigger('input');            
          }
        });
      })
    },

    handleCalculations: function(){
      var self = this;
      $(document).on('input', '.qty', function(){
        var total = 0;

        item = $(this).parents('.cart-item');
        qty = parseFloat($(this).val());
        price = parseFloat(item.find('.price').data('value'));
        amount = parseFloat(qty * price).toFixed(2)


        if(amount){

          item.find('.item-total').html(amount);
          item.find('.item-total').data('item-value', amount);

          $('.item-total').each(function(){
            total += parseFloat($(this).data('item-value'));
          })

          withDiscount = total - parseFloat(self.disCountAmount())

          $('.total').html(withDiscount.toFixed(2));
        }
      })
    },

    disCountAmount: function(){
      var sum = 0;
      $('.apply-coupne').each(function(){
        if($(this).prop('checked') == true){
          sum += $(this).val();
        }
      })

      return sum;
    },

    applyCoupnes: function(){
      $(document).on('click', '.apply-coupne', function(){

        if($(this).prop('checked') == true){

          coupneAmount = parseFloat($(this).val());
          amount = parseFloat($('.total').html())

          afterCoupneApplyAmount = (amount - coupneAmount).toFixed(2);

          if(coupneAmount <= amount){
            $('.total').html(afterCoupneApplyAmount);
          }else{

          }
        }else{
          $('.qty').trigger('input');
        }

      })
    },


    applyAddToCartHtml: function(cartItemZ, productId){
      var productCard = cartItemZ.parent();
      var position = productCard.offset();
      var productImage = $(productCard).find('img').get(0).src;
      var productName = $(productCard).find('.product_name').get(0).innerHTML;        
      var productPrice = $(productCard).find('.product_price').get(0).innerHTML;

      $("body").append('<div class="floating-cart"></div>');    
      var cart = $('div.floating-cart');    
      productCard.clone().appendTo(cart);
      $(cart).css({'top' : position.top + 'px', "left" : position.left + 'px'}).fadeIn("slow").addClass('moveToCart');    
      setTimeout(function(){$("body").addClass("MakeFloatingCart");}, 800);
      setTimeout(function(){
        $('div.floating-cart').remove();
        $("body").removeClass("MakeFloatingCart");


        var cartItem = "<div class='cart-item'><div class='img-wrap'><img src='"+productImage+"' alt='' /></div><span>"+productName+"</span><strong>"+ productPrice +"</strong><div class='cart-item-border'></div><div class='delete-item' data-cart-id="+ productId +"></div></div>";     

        $("#cart .empty").hide();     
        $("#cart").append(cartItem);
        $("#checkout").fadeIn(500);
        
        $("#cart .cart-item").last()
          .addClass("flash")
          .find(".delete-item").click(function(){
            $(this).parent().fadeOut(300, function(){
              $(this).remove();
              if($("#cart .cart-item").size() == 0){
                $("#cart .empty").fadeIn(500);
                $("#checkout").fadeOut(500);
              }
            })
          });
          setTimeout(function(){
          $("#cart .cart-item").last().removeClass("flash");
        }, 10 );
        
      }, 1000);

    }

   
  }

  handleProcess.init();

})