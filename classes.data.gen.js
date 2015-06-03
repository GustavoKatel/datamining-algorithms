var fs = require("fs");
var chance = require("chance").Chance();

var total_classes = chance.integer({min: 2, max:30});
var total_rows = 1000;

var classes = [];
for(var i=1;i<=total_classes;i++){
  classes.push("c"+i);
}

var wstream = fs.createWriteStream("data/classes.csv");
wstream.write("student_id,"+classes.join(",")+"\n");


for(var i=1;i<=total_rows;i++){

  var c1 = false;
  wstream.write("s"+i+","+

    classes.map(function(class_id){

      if(class_id=="c1"){
        c1 = chance.bool();
        return c1 ? "1" : "0";
      }

      // c2=1 after c1=1 with a likelihood of 80
      if(class_id=="c2") {
        if(c1 && chance.bool({likelihood: 80}))
          return 1;
        else
          return 0;
      }

      return chance.integer({min: 0, max: 1});
    }).join(",")

    +"\n"

  );
}


wstream.end();
