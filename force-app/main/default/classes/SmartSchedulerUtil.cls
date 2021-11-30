public with sharing class SmartSchedulerUtil {
    
    public static List<SmartSchedulerUtil.Schedule> getTimeSlot(){
        Time strTime  = Time.newInstance(9,0,0,0);
        Time endTime  = Time.newInstance(17,0,0,0);
        List<SmartSchedulerUtil.Schedule> bookedTS = new List<SmartSchedulerUtil.Schedule>();
        bookedTS.add(new SmartSchedulerUtil.Schedule(Time.newInstance(9,0,0,0), Time.newInstance(10,0,0,0)));
        bookedTS.add(new SmartSchedulerUtil.Schedule(Time.newInstance(11,0,0,0), Time.newInstance(13,0,0,0)));
        bookedTS.add(new SmartSchedulerUtil.Schedule(Time.newInstance(16,0,0,0), Time.newInstance(17,0,0,0)));
        List<SmartSchedulerUtil.Schedule> newTS = new  List<SmartSchedulerUtil.Schedule>();
        while(strTime != endTime){
            time timeStr = strTime;
            time timeEnd =  strTime.addMinutes(30);
            System.debug(timeStr+'---'+timeEnd);
            Boolean isBooked = false;
            for(SmartSchedulerUtil.Schedule objsmSchedule : bookedTS ){
                if(timeStr >= objsmSchedule.startTime && timeEnd <= objsmSchedule.endTIme){
                    isBooked = true;
                }
            }
            if(!isBooked){
                newTS.add(new SmartSchedulerUtil.Schedule(timeStr, timeEnd));
               
            }
           
            strTime =  strTime.addMinutes(30);

        }
        return newTS;
    }
    public class Schedule{
        public Time startTime;
        public Time endTIme;
        public Schedule(Time t1, Time t2){
            startTime = t1;
            endTime = t2;
        }
    }
}