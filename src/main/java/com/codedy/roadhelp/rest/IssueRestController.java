package com.codedy.roadhelp.rest;

import com.codedy.roadhelp.dto.WebSocketDto;
import com.codedy.roadhelp.model.Issue;
import com.codedy.roadhelp.model.RatingIssue;
import com.codedy.roadhelp.model.User;
import com.codedy.roadhelp.model.enums.IssueStatus;
import com.codedy.roadhelp.rest.exception.RestNotFoundException;
import com.codedy.roadhelp.service.issue.IssueService;
import com.codedy.roadhelp.service.ratingIssue.RatingIssueService;
import com.codedy.roadhelp.service.user.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@RestController
@RequestMapping(path = "/api/v1/issues")
public class IssueRestController {

    @Autowired
    SimpMessagingTemplate simpMessagingTemplate;
    //region - Autowired Service -
    @Autowired
    private IssueService issueService;
    @Autowired
    private RatingIssueService ratingIssueService;
    @Autowired
    private UserService userService;
    //endregion

    //region - Base -

    // List
    @GetMapping(path = {"", "/", "/index"})
    public List<LinkedHashMap<String, Object>> index(@RequestParam(required = false, defaultValue = "0") double latitude,
                                                     @RequestParam(required = false, defaultValue = "0") double longitude,
                                                     @RequestParam(required = false, defaultValue = "0") int distance) {

        // Nếu có Vị trí gần nhất
        if (latitude != 0 || longitude != 0 || distance > 0) { //Vị trí latitude, longitude có thể là số âm không nhỉ ??
            List<Issue> issues = issueService.findAll(); //TODO: hiệu năng kém

            return this.filterNearMe(issues, latitude, longitude, distance).stream().map(Issue::toApiResponse).toList();
        }

        return issueService.findAll().stream().map(Issue::toApiResponse).toList();
    }

    // Detail
    @GetMapping(path = {"/{id}", "/{id}/"})
    public LinkedHashMap<String, Object> show(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        return issue.toApiResponse();
    }

    // Create
    @PostMapping(path = {"", "/"})
    public LinkedHashMap<String, Object> store(@RequestBody Issue issue) {
        issue.setId(0);


        return issueService.save(issue).toApiResponse();
    }

    // Update
    @PutMapping(path = {"/{id}", "/{id}/"})
    public LinkedHashMap<String, Object> update(@RequestBody Issue issue, @PathVariable int id) {
        if (!issueService.existsById(id)) {
            throw new RestNotFoundException("Issue id not found - " + id);
        }

        issue.setId(id);

        return issueService.save(issue).toApiResponse();
    }

    // Delete
    @DeleteMapping(path = {"/{id}", "/{id}/"})
    public String delete(@PathVariable int id) {
        if (!issueService.existsById(id)) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        issueService.deleteById(id);

        return "Deleted issue id - " + id;
    }
    //endregion


    //region - Extend -
    // = = = = = = = = = = = = = = = For Member = = = = = = = = = = = = = = = //

    // List byUserMember - Lịch sử danh sách issue của member đã gửi
    @GetMapping(path = {"/byUserMember/{userMemberId}", "/byUserMember/{userMemberId}/"})
    public List<LinkedHashMap<String, Object>> byUserMember(@PathVariable int userMemberId) {
        return issueService.findAllByUserMemberId(userMemberId).stream().map(Issue::toApiResponse).toList();
    }

    // Member Gửi yêu cầu cứu hộ
    @PostMapping(path = {"/send", "/send/"})
    public LinkedHashMap<String, Object> sendIssue(@RequestBody Issue issue) {
        issue.setStatus(IssueStatus.sent);
        return this.store(issue);
    }

    // Member Xem thông tin người giúp đỡ mình
    @GetMapping(path = {"/{id}/userPartner", "/{id}/userPartner/"})
    public LinkedHashMap<String, Object> userPartner(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getUserPartner() == null) {
            throw new RestNotFoundException("UserPartner for Issues id not found - " + id);
        }

        return issue.getUserPartner().toApiResponse();
    }

    // Member Xác nhận thông tin người giúp đỡ mình
    @PutMapping(path = {"/{id}/member-confirm-partner", "/{id}/member-confirm-partner/"})
    public LinkedHashMap<String, Object> memberConfirmPartner(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getStatus() != IssueStatus.waitMemberConfirm) {
            throw new RuntimeException("Lỗi: Không trong trạng thái 'chờ khách hàng xác nhận', Status hiện tại: " + issue.getStatus());
            //throw new RuntimeException("Lỗi: Không trong trạng thái 'waitMemberConfirm', Status hiện tại: " + issue.getStatus());
        }

        issue.setStatus(IssueStatus.memberConfirmPartner);

        issueService.save(issue);

        // Gửi thông báo tới máy Partner bằng WebSocket :
        LinkedHashMap<String, Object> data = new LinkedHashMap<>();
        data.put("issueStatus", issue.getStatus());
        WebSocketDto webSocketDto = new WebSocketDto();
        webSocketDto.setData(data);
        webSocketDto.setMessage("Issue này Member đã xác nhận Partner tới giúp."); // Không cần thiết, chỉ test thôi
        simpMessagingTemplate.convertAndSend("/topic/issue/partnerWaitMember/" + issue.getId(), webSocketDto);

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Xác nhận '" + issue.getUserPartner().getFirstName() + " " + issue.getUserPartner().getLastName() + "' là người hỗ trợ!");
        return response;
    }

    // Member viết đánh giá issue sau khi được cứu hộ xong -
    @PostMapping(path = {"/{issueId}/ratingIssue", "/{issueId}/ratingIssue/"})
    public LinkedHashMap<String, Object> ratingIssue(@RequestBody RatingIssue ratingIssue, @PathVariable int issueId) {
        ratingIssue.setId(0);

        Issue issue = issueService.findById(issueId);
        ratingIssue.setIssue(issue);

        return ratingIssueService.save(ratingIssue).toApiResponse();
    }

    // Hủy bởi Member
    @PutMapping(path = {"/{id}/canceledByMember", "/{id}/canceledByMember/"})
    public LinkedHashMap<String, Object> canceledByMember(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getStatus() == IssueStatus.canceledByPartner || issue.getStatus() == IssueStatus.succeeded) {
            throw new RuntimeException("Lỗi: Trạng thái hiện tại không hợp lệ: " + issue.getStatus());
        }

        issue.setStatus(IssueStatus.canceledByMember);

        issueService.save(issue);

        // Gửi thông báo tới máy member bằng WebSocket :
        LinkedHashMap<String, Object> data = new LinkedHashMap<>();
        data.put("issueStatus", issue.getStatus());
        WebSocketDto webSocketDto = new WebSocketDto();
        webSocketDto.setData(data);
        webSocketDto.setMessage("Issue này đã Bị hủy bởi Member."); // Không cần thiết, chỉ test thôi
        simpMessagingTemplate.convertAndSend("/topic/issue/partnerWaitMember/" + issue.getId(), webSocketDto);

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Issue có ID " + id + " được thay đổi trạng thái thành: 'Hủy bởi khách hàng'");
        return response;
    }


    // = = = = = = = = = = = = = = = For Partner = = = = = = = = = = = = = = = //

    // List UserPartner - Lịch sử danh sách issue của partner đã nhận
    @GetMapping(path = {"/byUserPartner/{userPartnerId}", "/byUserPartner/{userPartnerId}/"})
    public List<LinkedHashMap<String, Object>> byUserPartner(@PathVariable int userPartnerId) {
        return issueService.findAllByUserPartnerId(userPartnerId).stream().map(Issue::toApiResponse).toList();
    }

    // Partner Xem danh sách những người đang cần hỗ trợ
    @GetMapping(path = {"/byStatusSent", "/byStatusSent/"})
    public List<LinkedHashMap<String, Object>> showListRescue(@RequestParam(required = false, defaultValue = "0") double latitude,
                                                            @RequestParam(required = false, defaultValue = "0") double longitude,
                                                            @RequestParam(required = false, defaultValue = "0") int distance) {

        List<Issue> issues = issueService.findIssueByStatus(IssueStatus.sent);

        // Nếu có Vị trí gần nhất
        if (latitude != 0 || longitude != 0 || distance > 0) { //Vị trí latitude, longitude có thể là số âm không nhỉ ??
            return this.filterNearMe(issues, latitude, longitude, distance).stream().map(Issue::toApiResponse).toList();
        }

        return issues.stream().map(Issue::toApiResponse).toList();
    }

    // Partner Xác nhận giúp
    @PutMapping(path = {"/{id}/partner-confirm-member/{userPartnerId}", "/{id}/partner-confirm-member/{userPartnerId}/"})
    public LinkedHashMap<String, Object> partnerConfirmMember(@PathVariable int id, @PathVariable int userPartnerId) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getStatus() != IssueStatus.sent) {
            throw new RuntimeException("Lỗi: Không trong trạng thái 'sent', Status hiện tại: " + issue.getStatus());
        }

        // Set UserPartner :
        User userPartner = userService.findById(userPartnerId);
        if (userPartner == null) {
            throw new RestNotFoundException("userPartner id not found - " + id);
        }
        issue.setUserPartner(userPartner);

        // Set Status :
        issue.setStatus(IssueStatus.waitMemberConfirm);

        issueService.save(issue);

        // Gửi thông báo tới máy member bằng WebSocket :
        LinkedHashMap<String, Object> data = new LinkedHashMap<>();
        data.put("issueStatus", issue.getStatus());
        WebSocketDto webSocketDto = new WebSocketDto();
        webSocketDto.setData(data);
        webSocketDto.setMessage("Issue này đã được Partner xác nhận giúp."); // Không cần thiết, chỉ test thôi
        simpMessagingTemplate.convertAndSend("/topic/issue/memberWaitPartner/" + issue.getId(), webSocketDto);

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Bạn đã xác nhận muốn hỗ trợ: '" + issue.getUserMember().getFirstName() + " " + issue.getUserMember().getLastName() + "'");
        return response;
    }

    // Partner Xem đánh giá sau khi hỗ trợ xong
    @GetMapping(path = {"/{id}/ratingIssue", "/{id}/ratingIssue/"})
    public LinkedHashMap<String, Object> ratingIssue(@PathVariable int id) {
        return ratingIssueService.findByIssueId(id).toApiResponse();
    }

    // Partner xác nhận hoàn thành sau khi partner hỗ trợ xog
    @PutMapping(path = {"/{id}/setStatusSuccess", "/{id}/setStatusSuccess/"})
    public LinkedHashMap<String, Object> setStatusSuccess(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getStatus() != IssueStatus.memberConfirmPartner) {
            throw new RuntimeException("Lỗi: Trạng thái hiện tại không phải là memberConfirmPartner, Status hiện tại: " + issue.getStatus());
        }

        issue.setStatus(IssueStatus.succeeded);

        issueService.save(issue);

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Issue có ID " + id + " được thay đổi trạng thái thành: 'Thành công'");
        return response;
    }

    // Hủy bởi Partner
    @PutMapping(path = {"/{id}/canceledByPartner", "/{id}/canceledByPartner/"})
    public LinkedHashMap<String, Object> canceledByPartner(@PathVariable int id) {
        Issue issue = issueService.findById(id);

        if (issue == null) {
            throw new RestNotFoundException("Issues id not found - " + id);
        }

        if (issue.getStatus() == IssueStatus.canceledByMember || issue.getStatus() == IssueStatus.succeeded) {
            throw new RuntimeException("Lỗi: Trạng thái hiện tại không hợp lệ: " + issue.getStatus());
        }

        issue.setStatus(IssueStatus.canceledByPartner);

        issueService.save(issue);

        LinkedHashMap<String, Object> response = new LinkedHashMap<>();
        response.put("message", "Issue có ID " + id + " được thay đổi trạng thái thành: 'Hủy bởi đối tác'");
        return response;
    }
    //endregion


    //region - Common Method -

    // Tính khoảng cách
    private double calculateDistanceInMeters(double lat1, double long1, double lat2, double long2) {
        return org.apache.lucene.util.SloppyMath.haversinMeters(lat1, long1, lat2, long2);
    }

    // Lọc theo vị trí gần tôi
    private List<Issue> filterNearMe(List<Issue> issues, double latitude, double longitude, int distance) {
        List<Issue> issueNearMe = new ArrayList<>();

        for (Issue issue : issues) {
            double value = calculateDistanceInMeters(issue.getLatitude(), issue.getLongitude(), latitude, longitude);
            if (value <= distance) {
                issueNearMe.add(issue);
            }
        }

        return issueNearMe;
    }

    //endregion

}
