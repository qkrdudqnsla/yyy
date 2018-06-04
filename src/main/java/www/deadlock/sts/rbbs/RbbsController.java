package www.deadlock.sts.rbbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.mail.Session;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import www.deadlock.model.rbbs.IrbbsDAO;
import www.deadlock.model.rbbs.RbbsDAO;
import www.deadlock.model.rbbs.RbbsDTO;
import www.deadlock.utility.Utility;

@Controller
public class RbbsController {

	@Autowired
	private IrbbsDAO dao;
	
	
	@RequestMapping("/template/bbslist")
	public String bbslist() {
		
		return "/template/bbslist";
	}
	
	
	@RequestMapping("/rbbs/error")
	public String error() {

		return "/rbbs/error";
	}
	

	@RequestMapping("/rbbs/list")
	public String list(HttpServletRequest request, Model model) {

		String col = Utility.checkNull(request.getParameter("col"));
		String word = Utility.checkNull(request.getParameter("word"));
		

		// --------------------------------------------------------------
		int nowPage = 1;
		if (request.getParameter("nowPage") != null) {
			nowPage = Integer.parseInt(request.getParameter("nowPage"));
		}
		int recordPerPage = 10;
		int sno = ((nowPage - 1) * recordPerPage) + 1;
		int eno = nowPage * recordPerPage;

		// --------------------------------------------------------------
		Map map = new HashMap();
		map.put("col", col);
		map.put("word", word);
		map.put("sno", sno);
		map.put("eno", eno);
		if(word == null) {
			word = "";
		}
		List list;
		try {
			list = dao.list(map);

			int totalRecord = dao.total(map);

			String paging = Utility.paging_rbbs(totalRecord, nowPage, recordPerPage, col, word);

			request.setAttribute("list", list);
			request.setAttribute("nowPage", nowPage);
			request.setAttribute("paging", paging);
			request.setAttribute("col", col);
			request.setAttribute("word", word);

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return "/rbbs/list";
	}

	@RequestMapping(value = "/rbbs/create", method = RequestMethod.GET)
	public String create() {

		return "/rbbs/create";
	}

	@RequestMapping(value = "/rbbs/create", method = RequestMethod.POST)
	public String create(RbbsDTO dto, HttpServletRequest request) throws Exception {
		String basePath = request.getRealPath("/storage_rbbs");
		String filename = Utility.saveFileSpring30(dto.getFnameMF(), basePath);
		int filesize = (int) dto.getFnameMF().getSize();

		dto.setFname(filename);
		if (dao.create(dto)) {
			return "redirect:/rbbs/list";

		} else {
			return "/rbbs/error";
		}

	}

	@RequestMapping("/rbbs/read")
	public String read(HttpServletRequest request, Model model) throws Exception {
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		String id = (String)request.getSession().getAttribute("id");
		if(id == "") {
			return "/rbbs/aderror";
		}
		boolean gflag = false;
		gflag= dao.vCheck(id);
		RbbsDTO dto = (RbbsDTO) dao.read(rnum);
		boolean flag = dto.getId().equals(id);
		boolean ggflag = id.equals(dao.idC(dto.getRefnum()));
		
		
		if(gflag || flag || ggflag) {

		
		dao.upViewCount(rnum);
		
		model.addAttribute("grade", gflag);
		model.addAttribute("dto", dto);
		model.addAttribute("rnum", rnum);

		return "/rbbs/read";
		}else {
		return "/rbbs/aderror";
		}
	}

	@RequestMapping("/rbbs/delete")
	public String delete(HttpServletRequest request,Model model) throws Exception {
		
		Map map = new HashMap();
		String basePath = request.getRealPath("./storage_rbbs");
		String oldfile = request.getParameter("oldfile");
		String id = (String)request.getSession().getAttribute("id");
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		
		if(dao.refC(rnum)) {
			return "/rbbs/error";
		}

		map.put("id", id);
		map.put("rnum", rnum);

		boolean flag = dao.idCheck(map);
		

		if (flag) {

			if (dao.delete(rnum)) {
				
				if(oldfile != null) {
					Utility.deleteFile(basePath, oldfile);
				}
				model.addAttribute("nowPage",request.getParameter("nowPage"));
				model.addAttribute("col",request.getParameter("col"));
				model.addAttribute("word",request.getParameter("word"));
				
				return "redirect:/rbbs/list";
			} else {
				return "/rbbs/error";
			}

		} else {
			return "/rbbs/error";
		}

	}

	@RequestMapping(value = "/rbbs/reply", method = RequestMethod.GET)
	public String createreply(HttpServletRequest request,Model model) throws Exception {
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		RbbsDTO dto = (RbbsDTO) dao.read(rnum);
		
		int grpno = dto.getGrpno();
		int indent = dto.getIndent();
		int ansnum	= dto.getAnsnum();
		
		model.addAttribute("rnum", rnum);
		model.addAttribute("grpno", grpno);
		model.addAttribute("indent", indent);
		model.addAttribute("ansnum", ansnum);
		
		return "/rbbs/reply";
	}
	
	@RequestMapping(value = "/rbbs/reply", method = RequestMethod.POST)
	public String createreply(RbbsDTO dto, HttpServletRequest request) {
		
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		dto.setRnum(rnum);
		String basePath = request.getRealPath("/storage_rbbs");
		String filename = Utility.saveFileSpring30(dto.getFnameMF(), basePath);
		int filesize = (int) dto.getFnameMF().getSize();

		dto.setFname(filename);
		
		boolean flag = dao.createReply(dto);
		
		if(flag) {
			return "redirect:/rbbs/list";
			
		}else {
			return "/rbbs/error";
		}
		
	}

	@RequestMapping(value= "/rbbs/update" , method = RequestMethod.GET)
	public String update(HttpServletRequest request, Model model) throws Exception {

		int rnum = Integer.parseInt(request.getParameter("rnum"));
		
		RbbsDTO dto = (RbbsDTO) dao.read(rnum);

		
		model.addAttribute("rnum", rnum);
		model.addAttribute("dto", dto);
		
		return "/rbbs/update";
	}
	
	@RequestMapping(value="/rbbs/update", method = RequestMethod.POST)
	public String update(RbbsDTO dto ,HttpServletRequest request, Model model) throws Exception {
		
		String oldfile = request.getParameter("oldfile");
		int rnum = Integer.parseInt(request.getParameter("rnum"));
		dto.setRnum(rnum);
		String basePath = request.getRealPath("/storage_rbbs");
		String filename = Utility.saveFileSpring30(dto.getFnameMF(), basePath);
		int filesize = (int) dto.getFnameMF().getSize();
		
		if(filesize > 0) {
			Utility.deleteFile(basePath, oldfile);
			dto.setFname(filename);
		
		}else {
			dto.setFname(oldfile);
		}
		
		boolean flag = dao.update(dto);
		
		if(flag) {
			model.addAttribute("nowPage", request.getParameter("nowPage"));
			model.addAttribute("col",request.getParameter("col"));
			model.addAttribute("word",request.getParameter("word"));
			
			return  "redirect:/rbbs/list";
		}else {
		
			return "/rbbs/error";
		}
		
	}
	
	
}
