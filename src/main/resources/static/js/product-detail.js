class ProductDetailPage {
    constructor() {
        this.productId = window.location.pathname.split('/').pop();
        this.selectedSize = null;
        this.product = null;
        this.selectedRating = 0;
        this.currentUser = null;
        this.init();
    }

    init() {
        this.bindEvents();
        this.loadProductDetails();
        this.checkUserAuth();
        this.loadReviews();
    }

    bindEvents() {
        // Quantity controls
        document.getElementById('decrease-qty').addEventListener('click', () => {
            this.changeQuantity(-1);
        });

        document.getElementById('increase-qty').addEventListener('click', () => {
            this.changeQuantity(1);
        });

        document.getElementById('quantity-input').addEventListener('change', (e) => {
            const value = parseInt(e.target.value);
            if (value < 1) e.target.value = 1;
            if (value > 99) e.target.value = 99;
        });

        // Add to cart button
        document.getElementById('add-to-cart-btn').addEventListener('click', () => {
            this.addToCart();
        });

        // Star rating selection
        document.getElementById('star-rating').addEventListener('click', (e) => {
            if (e.target.classList.contains('star')) {
                this.selectRating(parseInt(e.target.dataset.rating));
            }
        });

        // Review form submission
        document.getElementById('review-form').addEventListener('submit', (e) => {
            e.preventDefault();
            this.submitReview();
        });
    }

    async checkUserAuth() {
        try {
            const response = await fetch('/api/v1/users/current');
            if (response.ok) {
                this.currentUser = await response.json();
                document.getElementById('review-form-container').style.display = 'block';
                document.getElementById('login-prompt').style.display = 'none';
            } else {
                document.getElementById('review-form-container').style.display = 'none';
                document.getElementById('login-prompt').style.display = 'block';
            }
        } catch (error) {
            console.log('User not authenticated');
            document.getElementById('review-form-container').style.display = 'none';
            document.getElementById('login-prompt').style.display = 'block';
        }
    }

    selectRating(rating) {
        this.selectedRating = rating;
        const stars = document.querySelectorAll('#star-rating .star');
        stars.forEach((star, index) => {
            if (index < rating) {
                star.classList.add('active');
            } else {
                star.classList.remove('active');
            }
        });
    }

    async submitReview() {
        if (!this.selectedRating) {
            this.showError('Vui lòng chọn số sao đánh giá');
            return;
        }

        const title = document.getElementById('review-title').value.trim();
        const comment = document.getElementById('review-comment').value.trim();

        if (!comment) {
            this.showError('Vui lòng nhập nội dung đánh giá');
            return;
        }

        try {
            this.showLoading();

            const response = await fetch('/api/v1/reviews', {
                method: 'POST', headers: {
                    'Content-Type': 'application/json', 'X-User-Id': this.currentUser ? this.currentUser.id : ''
                }, body: JSON.stringify({
                    productId: parseInt(this.productId), rating: this.selectedRating, title: title, comment: comment
                })
            });

            if (response.ok) {
                this.showSuccess('Đánh giá của bạn đã được gửi thành công!');
                // Reset form
                document.getElementById('review-form').reset();
                this.selectedRating = 0;
                document.querySelectorAll('#star-rating .star').forEach(star => {
                    star.classList.remove('active');
                });
                // Reload reviews
                this.loadReviews();
            } else if (response.status === 401) {
                this.showError('Bạn cần đăng nhập để đánh giá');
                setTimeout(() => {
                    window.location.href = '/login';
                }, 2000);
            } else {
                const errorData = await response.json();
                this.showError(errorData.message || 'Không thể gửi đánh giá. Vui lòng thử lại!');
            }
        } catch (error) {
            console.error('Error submitting review:', error);
            this.showError('Có lỗi xảy ra. Vui lòng thử lại!');
        } finally {
            this.hideLoading();
        }
    }

    async loadReviews() {
        try {
            // Load reviews summary
            const summaryResponse = await fetch(`/api/v1/reviews/product/${this.productId}/summary`);
            if (summaryResponse.ok) {
                const summary = await summaryResponse.json();
                this.renderReviewsSummary(summary);
            }

            // Load reviews list
            const reviewsResponse = await fetch(`/api/v1/reviews/product/${this.productId}?page=0&size=10`);
            if (reviewsResponse.ok) {
                const reviewsData = await reviewsResponse.json();
                this.renderReviewsList(reviewsData.content || []);
            }
        } catch (error) {
            console.error('Error loading reviews:', error);
        }
    }

    renderReviewsSummary(summary) {
        document.getElementById('average-rating').textContent = summary.averageRating.toFixed(1);
        document.getElementById('total-reviews').textContent = `${summary.totalReviews} đánh giá`;

        // Render stars
        const starsHtml = this.renderStars(summary.averageRating);
        document.getElementById('stars-display').innerHTML = starsHtml;
    }

    renderStars(rating) {
        const fullStars = Math.floor(rating);
        const hasHalfStar = rating % 1 >= 0.5;
        const emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

        let html = '';
        for (let i = 0; i < fullStars; i++) {
            html += '★';
        }
        if (hasHalfStar) {
            html += '☆';
        }
        for (let i = 0; i < emptyStars; i++) {
            html += '☆';
        }
        return html;
    }

    renderReviewsList(reviews) {
        const reviewsList = document.getElementById('reviews-list');

        if (reviews.length === 0) {
            reviewsList.innerHTML = `
                        <div class="no-reviews">
                            <i class="fas fa-comments"></i>
                            <p>Chưa có đánh giá nào cho sản phẩm này.</p>
                            <p>Hãy là người đầu tiên chia sẻ trải nghiệm của bạn!</p>
                        </div>
                    `;
            return;
        }

        const reviewsHtml = reviews.map(review => `
                    <div class="review-item" data-review-id="${review.id}">
                        <div class="review-header">
                            <div class="reviewer-info">
                                <div class="reviewer-avatar">
                                    ${review.userName ? review.userName.charAt(0).toUpperCase() : 'U'}
                                </div>
                                <div class="reviewer-details">
                                    <h5>${review.userName || 'Khách hàng'}</h5>
                                    <div class="review-date">${this.formatDate(review.createdAt)}</div>
                                </div>
                            </div>
                            <div class="review-rating">${this.renderStars(review.rating)}</div>
                        </div>
                        ${review.title ? `<div class="review-title">${review.title}</div>` : ''}
                        <div class="review-content">${review.comment}</div>
                        
                        <!-- Review Actions -->
                        <div class="review-actions">
                            ${this.currentUser ? `
                                <button class="action-btn" onclick="productPage.likeReview(${review.id})">
                                    <i class="fas fa-thumbs-up"></i> ${review.likes || 0}
                                </button>
                                <button class="action-btn" onclick="productPage.dislikeReview(${review.id})">
                                    <i class="fas fa-thumbs-down"></i> ${review.dislikes || 0}
                                </button>
                                <button class="action-btn" onclick="productPage.toggleReplyForm(${review.id})">
                                    <i class="fas fa-reply"></i> Trả lời
                                </button>
                            ` : ''}
                            
                            ${this.canDeleteReview(review) ? `
                                <button class="action-btn delete-btn" onclick="productPage.deleteReview(${review.id})">
                                    <i class="fas fa-trash"></i> Xóa
                                </button>
                            ` : ''}
                        </div>
                        
                        <!-- Reply Form - Hidden by default, only for logged-in users -->
                        ${this.currentUser ? `
                            <div class="reply-form" id="reply-form-${review.id}">
                                <textarea placeholder="Viết trả lời của bạn..." rows="3"></textarea>
                                <div class="btn-group">
                                    <button class="btn btn-primary btn-sm" onclick="productPage.submitReply(${review.id})">
                                        Gửi
                                    </button>
                                    <button class="btn btn-secondary btn-sm" onclick="productPage.toggleReplyForm(${review.id})">
                                        Hủy
                                    </button>
                                </div>
                            </div>
                        ` : ''}
                        
                        <!-- Replies Section -->
                        <div class="reply-section" id="replies-${review.id}">
                            ${review.replies && review.replies.length > 0 ? review.replies.map(reply => `
                                <div class="reply-item">
                                    <div class="reply-content">
                                        <strong>${reply.userName || 'Admin'}:</strong>
                                        ${reply.content}
                                        <small class="text-muted d-block">- ${this.formatDate(reply.createdAt)}</small>
                                    </div>
                                    ${this.canDeleteReply(reply) ? `
                                        <button class="btn btn-sm btn-outline-danger ms-2" onclick="productPage.deleteReply(${reply.id})" title="Xóa trả lời">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    ` : ''}
                                </div>
                            `).join('') : ''}
                        </div>
                    </div>
                `).join('');

        reviewsList.innerHTML = reviewsHtml;
    }

    canDeleteReview(review) {
        if (!this.currentUser) return false;

        // User can delete their own review
        if (this.currentUser.id === review.userId) return true;

        // Admin/Root can delete any review
        const userRole = this.currentUser.role;
        return userRole === 'ADMIN' || userRole === 'ROOT';
    }

    canDeleteReply(reply) {
        if (!this.currentUser) return false;

        // User can delete their own reply
        if (this.currentUser.id === reply.userId) return true;

        // Admin/Root can delete any reply
        const userRole = this.currentUser.role;
        return userRole === 'ADMIN' || userRole === 'ROOT';
    }

    async likeReview(reviewId) {
        if (!this.currentUser) {
            this.showError('Bạn cần đăng nhập để thích đánh giá');
            return;
        }

        try {
            const response = await fetch(`/api/v1/reviews/${reviewId}/like`, {
                method: 'POST', headers: {
                    'X-User-Id': this.currentUser.id
                }
            });

            if (response.ok) {
                this.loadReviews(); // Reload to update counts
            } else {
                this.showError('Không thể thích đánh giá');
            }
        } catch (error) {
            console.error('Error liking review:', error);
            this.showError('Có lỗi xảy ra');
        }
    }

    async dislikeReview(reviewId) {
        if (!this.currentUser) {
            this.showError('Bạn cần đăng nhập để không thích đánh giá');
            return;
        }

        try {
            const response = await fetch(`/api/v1/reviews/${reviewId}/dislike`, {
                method: 'POST', headers: {
                    'X-User-Id': this.currentUser.id
                }
            });

            if (response.ok) {
                this.loadReviews(); // Reload to update counts
            } else {
                this.showError('Không thể không thích đánh giá');
            }
        } catch (error) {
            console.error('Error disliking review:', error);
            this.showError('Có lỗi xảy ra');
        }
    }

    toggleReplyForm(reviewId) {
        if (!this.currentUser) {
            this.showError('Bạn cần đăng nhập để trả lời bình luận');
            return;
        }

        const replyForm = document.getElementById(`reply-form-${reviewId}`);
        if (replyForm) {
            replyForm.classList.toggle('show');

            // Focus vào textarea khi mở form
            if (replyForm.classList.contains('show')) {
                const textarea = replyForm.querySelector('textarea');
                if (textarea) {
                    setTimeout(() => textarea.focus(), 100);
                }
            }
        }
    }

    async submitReply(reviewId) {
        if (!this.currentUser) {
            this.showError('Bạn cần đăng nhập để trả lời bình luận');
            return;
        }

        const replyForm = document.getElementById(`reply-form-${reviewId}`);
        if (!replyForm) return;

        const textarea = replyForm.querySelector('textarea');
        const content = textarea.value.trim();

        if (!content) {
            this.showError('Vui lòng nhập nội dung trả lời');
            return;
        }

        try {
            const response = await fetch(`/api/v1/reviews/${reviewId}/replies`, {
                method: 'POST', headers: {
                    'Content-Type': 'application/json', 'X-User-Id': this.currentUser.id
                }, body: JSON.stringify({
                    content: content
                })
            });

            if (response.ok) {
                textarea.value = '';
                replyForm.classList.remove('show');
                this.loadReviews(); // Reload to show new reply
                this.showSuccess('Đã gửi trả lời thành công');
            } else {
                this.showError('Không thể gửi trả lời');
            }
        } catch (error) {
            console.error('Error submitting reply:', error);
            this.showError('Có lỗi xảy ra');
        }
    }

    async deleteReview(reviewId) {
        if (!confirm('Bạn có chắc chắn muốn xóa đánh giá này?')) {
            return;
        }

        try {
            this.showLoading();

            const response = await fetch(`/api/v1/reviews/${reviewId}`, {
                method: 'DELETE', headers: {
                    'X-User-Id': this.currentUser ? this.currentUser.id : '',
                    'X-User-Role': this.currentUser ? this.currentUser.role : 'GUEST'
                }
            });

            if (response.ok) {
                this.showSuccess('Đã xóa đánh giá thành công!');
                this.loadReviews(); // Reload reviews
            } else {
                this.showError('Không thể xóa đánh giá. Vui lòng thử lại!');
            }
        } catch (error) {
            console.error('Error deleting review:', error);
            this.showError('Có lỗi xảy ra. Vui lòng thử lại!');
        } finally {
            this.hideLoading();
        }
    }

    async deleteReply(replyId) {
        if (!confirm('Bạn có chắc chắn muốn xóa trả lời này?')) {
            return;
        }

        try {
            this.showLoading();

            const response = await fetch(`/api/v1/reviews/replies/${replyId}`, {
                method: 'DELETE', headers: {
                    'X-User-Id': this.currentUser ? this.currentUser.id : '',
                    'X-User-Role': this.currentUser ? this.currentUser.role : 'GUEST'
                }
            });

            if (response.ok) {
                this.showSuccess('Đã xóa trả lời thành công!');
                this.loadReviews(); // Reload reviews to update replies
            } else {
                this.showError('Không thể xóa trả lời. Vui lòng thử lại!');
            }
        } catch (error) {
            console.error('Error deleting reply:', error);
            this.showError('Có lỗi xảy ra. Vui lòng thử lại!');
        } finally {
            this.hideLoading();
        }
    }

    formatDate(dateString) {
        const date = new Date(dateString);
        return date.toLocaleDateString('vi-VN', {
            year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
        });
    }

    async loadProductDetails() {
        try {
            this.showLoading();
            const response = await fetch(`/api/v1/products/${this.productId}`);

            if (response.ok) {
                this.product = await response.json();
                this.renderProductDetails();
            } else {
                this.showError('Không tìm thấy sản phẩm');
            }
        } catch (error) {
            console.error('Error loading product:', error);
            this.showError('Lỗi khi tải thông tin sản phẩm');
        } finally {
            this.hideLoading();
        }
    }

    renderProductDetails() {
        if (!this.product) return;

        // Update product information
        document.getElementById('product-name').textContent = this.product.name || 'Product Name';
        document.getElementById('product-subtitle').textContent = this.product.subTitle || 'Product Category';
        document.getElementById('product-price').textContent = new Intl.NumberFormat('vi-VN', {
            style: 'currency', currency: 'VND'
        }).format(this.product.price || 0);
        document.getElementById('product-description').textContent = this.product.description || 'Chưa có mô tả sản phẩm.';

        document.getElementById('product-id').textContent = this.product.id;
        document.getElementById('product-stock').textContent = this.product.stock > 0 ? `Còn ${this.product.stock} sản phẩm` : 'Hết hàng';
        document.getElementById('product-color').textContent = this.product.color || '-';

        // Update image
        if (this.product.images && this.product.images.length > 0) {
            document.getElementById('main-image').src = this.product.images[0];
        } else {
            document.getElementById('main-image').src = '/img/products/default-product.jpg';
        }

        // Render size options
        this.renderSizeOptions();
    }

    renderSizeOptions() {
        const sizeOptionsContainer = document.getElementById('size-options');

        // Sample sizes - in a real app, this would come from the product data
        const availableSizes = ['US 7', 'US 8', 'US 9', 'US 10', 'US 11'];

        sizeOptionsContainer.innerHTML = availableSizes.map(size => `<button type="button" class="size-btn" data-size="${size}">${size}</button>`).join('');

        // Bind size selection events
        sizeOptionsContainer.addEventListener('click', (e) => {
            if (e.target.classList.contains('size-btn')) {
                this.selectSize(e.target);
            }
        });
    }

    selectSize(sizeButton) {
        // Remove previous selection
        document.querySelectorAll('.size-btn').forEach(btn => {
            btn.classList.remove('selected');
        });

        // Select new size
        sizeButton.classList.add('selected');
        this.selectedSize = sizeButton.dataset.size;

        // Enable add to cart button if size is selected and product is in stock
        this.updateAddToCartButton();
    }

    updateAddToCartButton() {
        const addToCartBtn = document.getElementById('add-to-cart-btn');
        const canAddToCart = this.selectedSize && this.product && this.product.stock > 0;

        addToCartBtn.disabled = !canAddToCart;
    }

    changeQuantity(delta) {
        const quantityInput = document.getElementById('quantity-input');
        let currentValue = parseInt(quantityInput.value) || 1;
        let newValue = currentValue + delta;

        if (newValue < 1) newValue = 1;
        if (newValue > 99) newValue = 99;

        quantityInput.value = newValue;
    }

    async addToCart() {
        if (!this.selectedSize) {
            this.showError('Vui lòng chọn size trước khi thêm vào giỏ hàng');
            return;
        }

        const quantity = parseInt(document.getElementById('quantity-input').value) || 1;

        try {
            this.showLoading();

            const response = await fetch('/api/v1/carts/add', {
                method: 'POST', headers: {
                    'Content-Type': 'application/json'
                }, body: JSON.stringify({
                    productId: this.productId, quantity: quantity
                })
            });

            if (response.ok) {
                this.showSuccess('Đã thêm sản phẩm vào giỏ hàng thành công!');
                // Update cart count in header
                if (window.updateHeaderCartCount) {
                    window.updateHeaderCartCount();
                }
            } else if (response.status === 401) {
                // User not authenticated
                window.location.href = '/login?error=authentication_required';
            } else {
                this.showError('Không thể thêm sản phẩm vào giỏ hàng. Vui lòng thử lại!');
            }
        } catch (error) {
            console.error('Error adding to cart:', error);
            this.showError('Có lỗi xảy ra. Vui lòng thử lại!');
        } finally {
            this.hideLoading();
        }
    }

    showSuccess(message) {
        const successElement = document.getElementById('success-message');
        const textElement = document.getElementById('success-text');
        textElement.textContent = message;
        successElement.style.display = 'block';

        setTimeout(() => {
            successElement.style.display = 'none';
        }, 3000);
    }

    showError(message) {
        const errorElement = document.getElementById('error-message');
        const textElement = document.getElementById('error-text');
        textElement.textContent = message;
        errorElement.style.display = 'block';

        setTimeout(() => {
            errorElement.style.display = 'none';
        }, 5000);
    }

    showLoading() {
        document.getElementById('loading-overlay').style.display = 'flex';
    }

    hideLoading() {
        document.getElementById('loading-overlay').style.display = 'none';
    }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.productPage = new ProductDetailPage();
});