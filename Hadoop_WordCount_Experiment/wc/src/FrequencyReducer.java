import java.io.IOException;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class FrequencyReducer extends Reducer<IntWritable, Text, IntWritable, Text> {
    public void reduce(IntWritable key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {
        StringBuilder words = new StringBuilder();
        for (Text val : values) {
            words.append(val.toString()).append(" ");
        }
        context.write(key, new Text(words.toString()));
    }
}
