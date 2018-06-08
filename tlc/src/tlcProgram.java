import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.NullWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
 
public class tlcProgram
{
    public static void main(String[] args) 
	throws Exception
    {
        if (args.length != 2) {
            System.err.println("Usage: TlcEtlDriver <input path> <output path>");
            System.exit(-1);
        }
 
        Job job = new Job();
	job.setJarByClass(tlcProgram.class);
        job.setJobName("TLC");
 	Configuration conf = job.getConfiguration();
        conf.set("mapreduce.output.textoutputformat.separator", ",");
 	job.setNumReduceTasks(0);
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
 
        job.setMapperClass(tlcMapper.class);
 
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);
 
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
