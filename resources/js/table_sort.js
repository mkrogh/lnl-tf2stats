/*Shims */
if(!Array.isArray){
  Array.isArray = function(vArg){
     return Object.prototype.toString.call(vArg) === "[object Array]";
  }
}
/* END Shims */

(function(){
  var $ = function(selector,obj){var obj = obj||document;return obj.querySelectorAll(selector);}
  var _ = {};
  _.each = function(elements, fn){
    for(var i = 0; i < elements.length; i++){
      //Call function with args (element, index)
      fn.call(elements[i],elements[i],i);
    }
  }
  _.observable = function(){
    var observers = [];
    var addObserver = function(observer){
      observers.push(observer);
    }

    var removeObserver= function(observer){
      var index = observers.indexOf(observer);
      if(index !== -1) observers.splice(index,1);
    }

    var notify = function(what){
      _.each(observers, function(observer){
        observer(what);
      });
    }

    return {
      addObserver: addObserver,
      removeObserver: removeObserver,
      notify: notify
    };
  };
  
  /*
    Find each column...
    Insert icon and attatch click handler
      * change icon
      * resets icon for other columns
      * reorder rows
  */

  /**
   * Creates a row model. Extracts text from rows for faster access.
   */
  var rowModel = function(row) {
    var columnSelector = "td";
    var columns = $(columnSelector, row);
    var data = []

    _.each(columns, function(elm, i){
      var value = elm.textContent;
      data[i] = parseInt(value, 10) || value
    });

    return {
      row: row,
      columns: data
    };
  }

  /**
   * Creates a new table model. A table model is used to sort rows based on a specific column.
   */
  var tableModel = function(table_selector, row_selector){
    var row_selector = row_selector|| "tbody tr";
    var table = $(table_selector)[0];
    var rows = [];
    
    var domRows = $(row_selector, table);

    _.each(domRows, function(row, i){
      rows[i] = rowModel(row);
    });

    var sort = function(column, reverse){
      var i = column || rows.length -1
      var desc_sort = function(a,b){
        if(a.columns[i] < b.columns[i])
          return 1;
        if(a.columns[i] > b.columns[i])
          return -1;
        // same same
        return 0;
      };
      
      if(reverse){
        rows.sort(function(a,b){desc_sort(b,a)});
      }else{
        rows.sort(desc_sort);
      }
      //Notify views?
    }

    return {
      rows: rows,
      sort: sort
    }
  }

 var table = tableModel(".table");
 table.sort(7, true);
 console.log(table.rows);
})();
