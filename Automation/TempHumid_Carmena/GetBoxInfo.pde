
Table table99;
int i99 = 0;
void GetBoxInfo() {



 table99 = loadTable("/Users/glab/Desktop/INPUT.txt","header, tsv");

  //println(table99.getRowCount() + " total rows in table"); 

  for (TableRow row : table99.rows()) {
  
    String id = row.getString("BIRD_ID");
    int species = row.getInt("STATUS");
    String name = row.getString("BOX_ID");
    BOXa[i99] = species;
    BIRD_ID[i99] = id;
     i99 = i99+1;
    //println(name + " (" + species + ") has BIRD " + id);
  }
i99 = 0;
 // print(BOXa);
  
}