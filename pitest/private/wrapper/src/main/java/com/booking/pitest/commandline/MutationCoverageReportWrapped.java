package com.booking.pitest.commandline;

import org.pitest.mutationtest.commandline.MutationCoverageReport;

import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class MutationCoverageReportWrapped {
    private static final String pattern = "\\$\\{([A-Za-z0-9_]+)\\}";
    private static final Pattern expr = Pattern.compile(pattern);

    public static void main(final String[] args) {
        Map<String, String> envMap = System.getenv();
        for (int i = 0; i < args.length; i++) {
            if (args[i].indexOf('$') < 0) {
                continue;
            }
            String text = args[i];
            Matcher matcher = expr.matcher(text);
            while (matcher.find()) {
                String key = matcher.group(1);
                if (!envMap.containsKey(key)) {
                    continue;
                }
                String envValue = envMap.get(key);
                Pattern sub = Pattern.compile(Pattern.quote(matcher.group(0)));
                text = sub.matcher(text).replaceAll(envValue);
            }
            args[i] = text;
        }
        MutationCoverageReport.main(args);
    }
}
