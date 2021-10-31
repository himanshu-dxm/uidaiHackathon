class Compare{
  static Future<String> compareDetails(String address,String perm)async{
    //address - given by user. perm - permanent values of address which are not editable like state
    try{
      var addlist = address.split(', ').map((e) { // data filtering by removing , and spaces
        e.replaceAll(',','');
        return e.toLowerCase();
      });

      var permlist = perm.split(', ').map((e) {// data filtering by removing , and spaces
        e.replaceAll(',','');
        return e.toLowerCase();
      });
      var res = []; //holds the resulting address
      print(addlist);
      print(permlist);
      for(var i in addlist)
      {
        if(!permlist.contains(i.toLowerCase())) //if i in permanent list no need to add
        {
          res.add(i);
        }
        else break;
      }
      // print(res);
      return res.join(', '); // join the data
    }catch(e)
    {
      return Future.error(e);//throw any error
    }
  }
}
