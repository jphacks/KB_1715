$(function(){
  function buildpost(post) {
    var posts = $('tbody').append(post);
    //'tbody'に'tr'以下のhtml全てをappendする
  }

  $(function(){
    setInterval(update, 10000);
    //10000ミリ秒ごとにupdateという関数を実行する
  });
  function update(){ //この関数では以下のことを行う
    if($('.posts')[0]){ //もし'posts'というクラスがあったら
      var post_id = $('.posts:last').data('id'); //一番最後にある'posts'というクラスの'id'というデータ属性を取得し、'post_id'という変数に代入
    } else { //ない場合は
      var post_id = 0 //0を代入
    }
    $.ajax({ //ajax通信で以下のことを行う
      url: location.href, //urlは現在のページを指定
      type: 'GET', //メソッドを指定
      data: { //railsに引き渡すデータは
        post: { id: post_id } //このような形(paramsの形をしています)で、'id'には'post_id'を入れる
      },
      dataType: 'json' //データはjson形式
    })
    .always(function(data){ //通信したら、成功しようがしまいが受け取ったデータ（@new_post)を引数にとって以下のことを行う
      $.each(data, function(i, data){ //'data'を'data'に代入してeachで回す
        buildpost(data); //buildpostを呼び出す
      });
    });
  }
});
