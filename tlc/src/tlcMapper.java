import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class tlcMapper extends Mapper<LongWritable, Text, Text, Text>
{
        private static final SimpleDateFormat dateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        public void map(LongWritable key, Text value, Context context)
                throws IOException, InterruptedException
        {

                String input = value.toString();
                String[] iparray = input.split(",");
		String fname = ((FileSplit) context.getInputSplit()).getPath().getName();
		String[] fnamearray = fname.split("_|-|\\.");
		
		//Skip headers and blank rows
                if (iparray[0].equalsIgnoreCase("VendorID") ||iparray[0].equalsIgnoreCase("vendor_id") )
          	{
                        return;
                }
                else if (iparray.length == 1)
                {
                        return;
                }
		
                //Iniitialization            
                String TimeString = "";
                String SpeedString = "";
		String DistanceString= "";
		String FareString = "";
		String TipString = "";
		String within_limit = "wlimit";
                String exceeded_limit = "xlimit";
                Double speed = 0.0;
                Double perhour = 3600.0;
                Double permin = 60.0;
                Double hours = 0.0;
                Double minutes = 0.0;
		Long timediff;
                Double secs = 0.0;
                Double secdiv = 1000.0;
		Double fare = 0.0;
		Double tip = 0.0;
		int yr_index = 2;
		int month_index = 3;
		int pickup_index = 1;
		int drop_index = 2;
		int distance_index = 4;
		int tip_index_1 = 13;
		int tip_index_2 = 15;
		int fare_index_1 = 17;
		int fare_index_2 = 18;
		int fare_index_3 = 16;
                
		try
                {
                        
			Date pick = dateformat.parse(iparray[pickup_index]);
                	Date drop = dateformat.parse(iparray[drop_index]);
			timediff = (drop.getTime() - pick.getTime());
			
			Double distance = Double.parseDouble(iparray[distance_index]);
	
			//Parsing for Tips column depending upon input file format
			if  ((fnamearray[yr_index].equals("2016"))  
			  && (fnamearray[month_index].equals("07") || fnamearray[month_index].equals("08") || fnamearray[month_index].equals("09")
			  ||  fnamearray[month_index].equals("10") || fnamearray[month_index].equals("11") || fnamearray[month_index].equals("12")))	
			{
                                tip = Double.parseDouble(iparray[tip_index_1]);
                        }
                        else
                        {
                                tip = Double.parseDouble(iparray[tip_index_2]);
                        }
			
			//Parsing for Fare coulmn depending upon input file format
			if 	(fnamearray[yr_index].equals("2013") || fnamearray[yr_index].equals("2014"))
			{
				fare = Double.parseDouble(iparray[fare_index_1]);
			}
			else if ((fnamearray[yr_index].equals("2015")) 
				|| ((fnamearray[yr_index].equals("2016")) &&
					(fnamearray[month_index].equals("01") || fnamearray[month_index].equals("02") || fnamearray[month_index].equals("03") ||
                          		 fnamearray[month_index].equals("04") || fnamearray[month_index].equals("05") || fnamearray[month_index].equals("06"))))
			{
				fare = Double.parseDouble(iparray[fare_index_2]);
			}
			else if ((fnamearray[yr_index].equals("2016")) &&
					(fnamearray[month_index].equals("07") || fnamearray[month_index].equals("08") || fnamearray[month_index].equals("09") ||
                                	 fnamearray[month_index].equals("10") || fnamearray[month_index].equals("11") || fnamearray[month_index].equals("12")))
			{
                                fare = Double.parseDouble(iparray[fare_index_3]);
                        }

			//Only process valid distance and where distance is greater than a mile, alternatively process records with a valid fare and fare exits.
			if (distance.isNaN() || distance < 1 || fare.isNaN() || fare <= 0)
			{
				return;
			}		
			
			//Speed Calculation
			secs    = timediff / secdiv;
                        hours   = secs / perhour;
                        minutes = secs / permin;
                        speed   = distance / hours;
			
			//Only process records which had a trip time
			if (secs.isNaN() || secs <=0)
			{
				return;
			}

                        TimeString  = String.format("%.2f", minutes);
			DistanceString = String.format("%.2f",distance);
                        SpeedString = String.format("%.2f", speed);
			FareString  = String.format("%.2f", fare);
			TipString   = String.format("%.2f", tip);
                }
                catch (ArithmeticException e)
                {
                        return;
                }
		catch (ParseException p)
		{
			return;
		}
		catch (NumberFormatException n)
		{
			return;
		}
		
		/*
  		  Create output string consisting of: 
		  Key as xlimit i.e Exceeded Limit and wlimit i.e Within Limit depending upon year ad speed limit applicable to that year
		  Value as YEAR, MONTH, SPEED, DISTANCE, TIME, TIPS, FARE corresponding to a record that is processed
		*/
		
                String output_string = fnamearray[yr_index]+","+fnamearray[month_index]+","+SpeedString+","+DistanceString+","+TimeString+","+TipString+","+FareString;
                
                if 	((fnamearray[yr_index].equals("2013") || fnamearray[yr_index].equals("2014")) && (speed > 25.0))
                {
                        context.write(new Text(exceeded_limit),new Text(output_string));
                }
                else if ((fnamearray[yr_index].equals("2013") || fnamearray[yr_index].equals("2014")) && (speed <= 25.0))
                {
                        context.write(new Text(within_limit), new Text(output_string));
                }
		else if ((fnamearray[yr_index].equals("2015") || fnamearray[yr_index].equals("2016")) && (speed > 30.0))
		{
			context.write(new Text(exceeded_limit),new Text(output_string));
		}
		else if ((fnamearray[yr_index].equals("2015") || fnamearray[yr_index].equals("2016")) && (speed <= 30.0))
		{
			context.write(new Text(within_limit), new Text(output_string));
		}

        }
}                    
