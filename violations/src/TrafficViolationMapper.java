import java.io.IOException;

import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.lib.input.FileSplit;

public class TrafficViolationMapper extends Mapper<LongWritable, Text, NullWritable, Text>
{
	private String year;
    private String month;
    private String precinct;
    private String borough;

    @Override
    protected void setup(Context context) throws IOException, InterruptedException 
    {
    	// Capturing the filename
        String fileName = ((FileSplit) context.getInputSplit()).getPath().getName();

        // Spliting the filename to get year, month and precinct
        String[] fileParts = fileName.split("--");

        year = fileParts[0];
        month = fileParts[1];
        precinct = fileParts[2].replaceAll("\\D+", "");
    }

  	@Override
	public void map(LongWritable key, Text value, Context context) throws IOException, InterruptedException 
	{
	  	int index = -1;

	  	String line = value.toString();
		String[] rowData = line.split(",");
		
		// Finding the row with Speeding data
		for (int i = 0; i < rowData.length; i++) 
		{
		    if (rowData[i].equalsIgnoreCase("Speeding"))
		    {
		    	index = i;
		    	break;
		    }
		}                
		if (index == -1) 
		{
			return;
		}

		// Calculating borough from precinct
		int precinctInteger = Integer.parseInt(precinct);

		if (precinctInteger >= 1 && precinctInteger <= 34)
			borough = "Manhattan";
		else if (precinctInteger >= 40 && precinctInteger <= 52)
			borough = "Bronx";
		else if (precinctInteger >= 60 && precinctInteger <= 94)
			borough = "Brooklyn";
		else if (precinctInteger >= 100 && precinctInteger <= 115)
			borough = "Queens";
		else if (precinctInteger >= 120 && precinctInteger <= 123)
			borough = "Staten Island";


		// Forming a string of borough, precinct, month, year, type and count
        String record = borough + "," + precinct + "," + month + "," + year + "," + rowData[index] + "," + rowData[index + 1]; 

        context.write(NullWritable.get(), new Text(record));
	}
}


			  	


