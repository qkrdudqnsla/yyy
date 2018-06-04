package www.deadlock.model.rbbs;

import java.util.List;
import java.util.Map;

import deadlock.DAOSTDInter;

public interface IrbbsDAO extends DAOSTDInter {
	
	
	public boolean upViewCount(int rnum);
	
	public boolean createReply(RbbsDTO dto);
	
	public boolean idCheck(Map map);
	
	public boolean vCheck(String id);
	
	public String idC(int refnum);
	
	public boolean refC(int rnum);
	
}
