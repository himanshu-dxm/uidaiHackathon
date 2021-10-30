class Compare{
  static Future<String> compareDetails(String address,String perm)async{
    //address - given by user. perm - permanent values of address which are not editable like state
    try{
      var addlist = address.split(' ').map((e) { // data filtering by removing , and spaces
        e.replaceAll(',','');
        return e.toLowerCase();
      });

      var permlist = perm.split(' ').map((e) {// data filtering by removing , and spaces
        e.replaceAll(',','');
        return e.toLowerCase();
      });

      var res = []; //holds the resulting address

      for(var i in addlist)
      {
        if(!permlist.contains(i.toLowerCase())) //if i in permanent list no need to add
        {
          res.add(i);
        }
      }
      print(res);
      return res.join(' '); // join the data
    }catch(e)
    {
      return Future.error(e);//throw any error
    }
  }
}











//String address,String location,String permanent
  // static Future<List<String>> compareDetails(String address,String location,String permanent)async
  // {
  //   try {
  //     List<String> addressList,locationList,permList;
  //     var res='';
  //     addressList = address.trim().split(',');
  //     locationList = location.trim().split(',');
  //     permList = permanent.split(',');
  //     addressList.removeWhere((item){
  //       return item == '\n' || item ==' ';
  //     });
  //     locationList.removeWhere((item){
  //       return item == '\n' || item ==' ';
  //     });
  //     print("addressList :"+addressList.toString());
  //     print("locationList :"+locationList.toString());
  //     print("locationList :"+permList.toString());
  //     var match=0,count=0;
  //     for(var i in addressList){
  //       for(var j in locationList){
  //         print("i :"+i.replaceAll(" ",'').replaceAll('\n', '').toString().toLowerCase()+" j: "+j.replaceAll(" ",'').replaceAll('\n', '').toString().toLowerCase());
  //         if(i.replaceAll(" ",'').replaceAll('\n', '').toString().toLowerCase()==j.replaceAll(" ",'').replaceAll('\n', '').toString().toLowerCase())
  //         {
  //           if(!permList.contains(i))
  //             {
  //               print("not");
  //               res+=i.toString()+", ";
  //               }
  //           match+=1;
  //         }
  //       }
  //         count++;
  //     }
  //     print(match);
  //     print(count);
  //     print("$res");
  //     print("percentage match :"+(100*(match/count)).toString());
  //     return [res,(100*(match/count)).toString()];
  //   } on Exception catch (e) {
  //     return Future.error('Error in comparision $e');
  //   }
  // }
// }