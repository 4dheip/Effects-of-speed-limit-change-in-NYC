import java.io.IOException;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class CollisionMapper
   extends Mapper <LongWritable, Text, NullWritable, Text>
{
   @Override
   public void map(LongWritable key, Text value, Context context)
       throws IOException, InterruptedException

   {

     FileSplit fileSplit = (FileSplit)context.getInputSplit();
     String filename = fileSplit.getPath().getName();
     String[] file_parts = filename.split("-");

     String line = value.toString();
     String[] file_cols = line.split(",");
     String final_string = "";
     String temp_prec_string = "";

     /* Extracting month and year from file name */
     int year = Integer.parseInt(file_parts[0]);
     int month = Integer.parseInt(file_parts[1]);
     String borough = ""; 

     /* Check for different boroughs in NYC */
     if(filename.contains("bk") || filename.contains("bn"))
     {   
       borough = "Brooklyn";
     }   
     else if(filename.contains("mn"))
     {   
       borough = "Manhattan";
     }   
     else if(filename.contains("bx"))
     {   
       borough = "Bronx";
     }   
     else if(filename.contains("qn"))
     {   
       borough = "Queens";
     }   
     else if(filename.contains("si"))
     {   
       borough = "Staten Island";
     }

     int final_precinct = 0;
     String num_collisions = "";
     String precinct_string = "";
     String collision_string = "";
     String injured_string = "";
     String killed_string = "";
   
     /* Handling for files from Jan 2013 - Feb 2014 */ 
     if(year < 2014 || (year == 2014 && month < 3))
     {
         precinct_string = file_cols[0];
         if(precinct_string.length() == 4)
         {
           temp_prec_string = precinct_string.substring(2);
           precinct_string = "";
           precinct_string = temp_prec_string;
         }
         else if(precinct_string.length() == 6)
         {
           temp_prec_string = precinct_string.substring(3);
           precinct_string = "";
           precinct_string = temp_prec_string;
         }
         if(precinct_string.contains("south") || precinct_string.contains("South"))
         {
           final_precinct = 14;
           precinct_string = Integer.toString(final_precinct);
         }
         else if(precinct_string.contains("north") || precinct_string.contains("North"))
         {
           final_precinct = 18;
           precinct_string = Integer.toString(final_precinct);
         }
         else if(precinct_string.contains("Park") || precinct_string.contains("park"))
         {
           final_precinct = 22;
           precinct_string = Integer.toString(final_precinct);
         }

         final_string = borough + "," + precinct_string + "," + file_parts[1] + "," + file_parts[0] + "," + file_cols[1] + "," + file_cols[2] + "," + file_cols[3];
         context.write(NullWritable.get(), new Text(final_string));
     }
     /* Handling for files from July 2015 - Dec 2016 */
     else if((line.startsWith("0") || line.startsWith("1")) && file_cols.length == 23)
     {
       final_string = borough + "," + file_cols[0] + "," + file_parts[1] + "," + file_parts[0] + "," + file_cols[3] + "," + file_cols[8] + "," + file_cols[9];
       context.write(NullWritable.get(), new Text(final_string));
     }
     /* Handling for files from Mar 2014 - June 2015 of xls format*/
     else if(line.startsWith("\"0") || line.startsWith("\"1"))
     {
       precinct_string= file_cols[0].replaceAll("[^0-9]", "");
       collision_string= file_cols[3].replaceAll("[^0-9]", "");
       injured_string= file_cols[8].replaceAll("[^0-9]", "");
       killed_string= file_cols[9].replaceAll("[^0-9]", "");

       final_string =  borough + "," + precinct_string + "," + file_parts[1] + "," + file_parts[0] + "," + collision_string + "," + injured_string + "," + killed_string;
       context.write(NullWritable.get(), new Text(final_string));
     }
   }
}
